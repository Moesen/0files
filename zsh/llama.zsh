### llama-server background controls
# Toggle on/off, tail logs, check status. State lives in /tmp.

LLAMA_SERVER_PID_FILE="/tmp/llama-server.pid"
LLAMA_SERVER_LOG_FILE="/tmp/llama-server.log"
LLAMA_SERVER_CMD=(llama-server --fim-qwen-7b-default --port 8012)

_llama-server-pid() {
  [[ -f $LLAMA_SERVER_PID_FILE ]] || return 1
  local pid
  pid=$(<"$LLAMA_SERVER_PID_FILE")
  [[ -n $pid ]] && kill -0 "$pid" 2>/dev/null && print -- "$pid"
}

llama-toggle() {
  local pid
  if pid=$(_llama-server-pid); then
    kill "$pid" && rm -f "$LLAMA_SERVER_PID_FILE"
    print "llama-server stopped (was pid $pid)"
  else
    rm -f "$LLAMA_SERVER_PID_FILE"
    nohup "${LLAMA_SERVER_CMD[@]}" >>"$LLAMA_SERVER_LOG_FILE" 2>&1 &!
    print -- $! >"$LLAMA_SERVER_PID_FILE"
    print "llama-server started (pid $!), logs at $LLAMA_SERVER_LOG_FILE"
  fi
}

llama-status() {
  local pid
  if pid=$(_llama-server-pid); then
    print "llama-server running (pid $pid) — port 8012, logs $LLAMA_SERVER_LOG_FILE"
  else
    print "llama-server not running"
  fi
}

llama-logs() {
  [[ -f $LLAMA_SERVER_LOG_FILE ]] || { print "no log file at $LLAMA_SERVER_LOG_FILE"; return 1 }
  tail -f "$LLAMA_SERVER_LOG_FILE"
}
