#!/bin/bash
set -e

# đảm bảo biến môi trường
export USER=${USER:-root}
export HOME=${HOME:-/root}

# Tạo thư mục .vnc và password nếu chưa có
mkdir -p "$HOME/.vnc"
if [ ! -f "$HOME/.vnc/passwd" ]; then
  echo "123456" | vncpasswd -f > "$HOME/.vnc/passwd"
  chmod 600 "$HOME/.vnc/passwd"
fi

# Tạo xstartup để khởi XFCE
cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x "$HOME/.vnc/xstartup"

if [ -x /usr/sbin/sshd ]; then
  /usr/sbin/sshd || true
fi

vncserver -kill :1 >/dev/null 2>&1 || true

vncserver :1 -geometry 1280x800 -depth 24 -localhost no

tail -F "$HOME/.vnc/"*.log || tail -f /dev/null
