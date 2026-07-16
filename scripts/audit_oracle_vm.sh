#!/usr/bin/env bash
set -u

# RIP Oracle VM operational baseline audit
# Read-only: this script does not install, remove, restart, or modify services.
# It deliberately avoids printing environment variables, credentials, and file contents.

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="${1:-$HOME/rip-audit-$STAMP.txt}"

exec > >(tee "$OUT") 2>&1

section() {
  printf '\n\n============================================================\n'
  printf '%s\n' "$1"
  printf '============================================================\n'
}

run() {
  printf '\n$ %s\n' "$*"
  "$@" 2>&1 || printf '[command failed or unavailable: %s]\n' "$*"
}

safe_shell() {
  printf '\n$ %s\n' "$1"
  bash -lc "$1" 2>&1 || printf '[command failed]\n'
}

section "RIP ORACLE VM AUDIT"
echo "Audit UTC: $(date -u --iso-8601=seconds)"
echo "Host: $(hostname 2>/dev/null || echo unknown)"
echo "User: $(id -un 2>/dev/null || echo unknown)"
echo "Output: $OUT"
echo "NOTE: Review output before sharing. The script avoids secrets, but hostnames and IP information may appear."

section "OPERATING SYSTEM AND HARDWARE"
run uname -a
safe_shell 'cat /etc/os-release 2>/dev/null | grep -E "^(NAME|VERSION|VERSION_ID|PRETTY_NAME)="'
run uname -m
run nproc
run free -h
run lscpu

section "DISK AND FILESYSTEM"
run df -hT
run lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
safe_shell 'du -sh "$HOME" 2>/dev/null || true'

section "UPTIME AND RESOURCE SNAPSHOT"
run uptime
run free -h
safe_shell 'ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 20'

section "NETWORK LISTENERS"
run ss -lntup

section "FIREWALL AND SELINUX"
safe_shell 'getenforce 2>/dev/null || true'
safe_shell 'systemctl is-active firewalld 2>/dev/null || true'
safe_shell 'firewall-cmd --list-all 2>/dev/null || true'

section "PODMAN AND COMPOSE"
run podman --version
safe_shell 'podman info --format "rootless={{.Host.Security.Rootless}} arch={{.Host.Arch}} os={{.Host.Os}} cgroup={{.Host.CgroupVersion}}" 2>/dev/null || podman info 2>/dev/null | head -n 80'
safe_shell 'podman compose version 2>/dev/null || docker compose version 2>/dev/null || true'

section "CONTAINERS"
safe_shell 'podman ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'

section "CONTAINER HEALTH"
safe_shell 'for c in $(podman ps -a --format "{{.Names}}"); do printf "%-32s " "$c"; podman inspect --format "status={{.State.Status}} health={{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}} restart={{.HostConfig.RestartPolicy.Name}}" "$c" 2>/dev/null || echo inspect-failed; done'

section "PODMAN NETWORKS"
run podman network ls
safe_shell 'for n in $(podman network ls --format "{{.Name}}"); do echo "--- $n"; podman network inspect "$n" --format "driver={{.Driver}} internal={{.Internal}} subnets={{range .Subnets}}{{.Subnet}} {{end}} labels={{json .Labels}}" 2>/dev/null || true; done'

section "PODMAN VOLUMES"
run podman volume ls
safe_shell 'for v in $(podman volume ls --format "{{.Name}}"); do echo "--- $v"; podman volume inspect "$v" --format "mount={{.Mountpoint}} driver={{.Driver}}" 2>/dev/null || true; done'

section "USER SYSTEMD AND REBOOT RECOVERY"
safe_shell 'loginctl show-user "$(id -un)" -p Linger 2>/dev/null || true'
safe_shell 'systemctl --user --no-pager --type=service --state=running 2>/dev/null || true'
safe_shell 'systemctl --user --no-pager list-unit-files 2>/dev/null | grep -Ei "n8n|podman|container|redis|postgres|nginx|paperclip|ollama" || true'

section "KEY SERVICE VERSIONS — NO SECRETS"
safe_shell 'for c in $(podman ps --format "{{.Names}}"); do img=$(podman inspect --format "{{.ImageName}}" "$c" 2>/dev/null); case "$img" in *postgres*) echo "--- $c ($img)"; podman exec "$c" postgres --version 2>/dev/null || true;; *redis*) echo "--- $c ($img)"; podman exec "$c" redis-server --version 2>/dev/null || true;; *n8n*) echo "--- $c ($img)"; podman exec "$c" n8n --version 2>/dev/null || true;; esac; done'

section "DATABASE AND REDIS PORT EXPOSURE"
safe_shell 'podman ps --format "{{.Names}}|{{.Image}}|{{.Ports}}" | grep -Ei "postgres|redis" || true'
echo "Expected: PostgreSQL and Redis should not be published on a public interface."

section "POSTGRES READINESS"
safe_shell 'for c in $(podman ps --format "{{.Names}}"); do img=$(podman inspect --format "{{.ImageName}}" "$c" 2>/dev/null); case "$img" in *postgres*) echo "--- $c"; podman exec "$c" pg_isready 2>/dev/null || true;; esac; done'

section "REDIS READINESS"
safe_shell 'for c in $(podman ps --format "{{.Names}}"); do img=$(podman inspect --format "{{.ImageName}}" "$c" 2>/dev/null); case "$img" in *redis*) echo "--- $c"; podman exec "$c" redis-cli PING 2>/dev/null || echo "PING requires authentication or failed";; esac; done'

section "N8N, PROXY, AND SERVICE PORT CLUES"
safe_shell 'podman ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}" | grep -Ei "n8n|nginx|proxy|paperclip|ollama|dashboard|scraper" || true'

section "DNS CLUES"
safe_shell 'command -v dig >/dev/null && { for h in n8n.mumoxa.co.za maps.mumoxa.co.za rip.mumoxa.co.za; do echo "--- $h"; dig +short "$h"; done; } || true'

section "TLS CLUES"
safe_shell 'command -v curl >/dev/null && { for u in https://n8n.mumoxa.co.za https://maps.mumoxa.co.za https://rip.mumoxa.co.za; do echo "--- $u"; curl -kIsS --max-time 10 "$u" | head -n 8 || true; done; } || true'

section "BACKUP CLUES"
safe_shell 'find "$HOME" -maxdepth 4 -type f \( -iname "*.sql" -o -iname "*.dump" -o -iname "*.backup" -o -iname "*workflow*.json" \) -printf "%TY-%Tm-%Td %TH:%TM %10s %p\n" 2>/dev/null | tail -n 50'
safe_shell 'systemctl --user --no-pager list-timers 2>/dev/null || true'
safe_shell 'systemctl --no-pager list-timers 2>/dev/null | grep -Ei "backup|postgres|n8n" || true'

section "RECENT FAILURES"
safe_shell 'systemctl --user --failed --no-pager 2>/dev/null || true'
safe_shell 'podman ps -a --filter status=exited --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'

section "AUDIT SUMMARY PLACEHOLDER"
echo "The raw audit has completed. No configuration was changed."
echo "Output file: $OUT"
echo "Next: review this report, redact any sensitive host/IP details if desired, and provide it for assessment."
