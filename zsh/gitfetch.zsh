### gitfetch - neofetch-style git identity inspector
# Shows the git config that's actually in effect for the current repo,
# tagging each value with its scope ([local]/[global]/[system]) so you
# can see at a glance whether a repo is overriding your defaults.

gitfetch() {
    emulate -L zsh
    setopt local_options pipefail

    # ANSI colors
    local C_RESET=$'\e[0m'
    local C_BOLD=$'\e[1m'
    local C_DIM=$'\e[2m'
    local C_RED=$'\e[31m'
    local C_GREEN=$'\e[32m'
    local C_YELLOW=$'\e[33m'
    local C_BLUE=$'\e[34m'
    local C_MAGENTA=$'\e[35m'
    local C_CYAN=$'\e[36m'
    local C_WHITE=$'\e[37m'
    local C_GREY=$'\e[90m'

    local in_repo=0
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 && in_repo=1

    # Fetch a config value and its scope. Sets reply=(scope value).
    _gf_get() {
        local key="$1"
        local line
        line=$(git config --show-scope --get "$key" 2>/dev/null) || return 1
        # `git config --show-scope` prints "<scope>\t<value>"
        local scope="${line%%	*}"
        local value="${line#*	}"
        reply=("$scope" "$value")
    }

    # Colorize a scope tag. Local override = green (likely intentional),
    # global = blue, system/worktree/command/other = grey.
    _gf_scope_color() {
        case "$1" in
            local|worktree)  print -n -- "${C_GREEN}" ;;
            global)          print -n -- "${C_BLUE}" ;;
            system)          print -n -- "${C_GREY}" ;;
            command)         print -n -- "${C_MAGENTA}" ;;
            *)               print -n -- "${C_GREY}" ;;
        esac
    }

    # Print a single labeled row: label, value, scope tag.
    _gf_row() {
        local label="$1" key="$2"
        local -a reply
        if _gf_get "$key"; then
            local scope="${reply[1]}" value="${reply[2]}"
            local sc; sc=$(_gf_scope_color "$scope")
            printf "  ${C_CYAN}%-14s${C_RESET} %s  %s[%s]%s\n" \
                "$label" "$value" "$sc" "$scope" "$C_RESET"
        else
            printf "  ${C_CYAN}%-14s${C_RESET} ${C_DIM}(unset)${C_RESET}\n" "$label"
        fi
    }

    # Header
    print -- ""
    if (( in_repo )); then
        local repo_root repo_name branch remote_url
        repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        repo_name="${repo_root:t}"
        branch=$(git symbolic-ref --short HEAD 2>/dev/null) \
            || branch=$(git rev-parse --short HEAD 2>/dev/null)"${C_DIM} (detached)${C_RESET}"
        remote_url=$(git config --get remote.origin.url 2>/dev/null)

        printf "${C_BOLD}${C_MAGENTA}  %s${C_RESET} ${C_DIM}on${C_RESET} ${C_YELLOW}%s${C_RESET}\n" \
            "$repo_name" "$branch"
        printf "  ${C_DIM}%s${C_RESET}\n" "$repo_root"
        [[ -n "$remote_url" ]] && \
            printf "  ${C_DIM}origin:${C_RESET} %s\n" "$remote_url"
    else
        printf "${C_BOLD}${C_MAGENTA}  (not in a git repo) — showing global config${C_RESET}\n"
    fi
    print -- ""

    # Identity
    printf "${C_BOLD}${C_WHITE}Identity${C_RESET}\n"
    _gf_row "name"        "user.name"
    _gf_row "email"       "user.email"
    _gf_row "username"    "user.username"
    print -- ""

    # Signing
    printf "${C_BOLD}${C_WHITE}Signing${C_RESET}\n"
    _gf_row "signingkey"  "user.signingkey"
    _gf_row "gpg.format"  "gpg.format"
    _gf_row "commit.sign" "commit.gpgsign"
    _gf_row "tag.sign"    "tag.gpgsign"

    # Resolve which gpg/ssh program is actually used for signing.
    local -a reply
    local fmt=""
    _gf_get "gpg.format" && fmt="${reply[2]}"
    [[ -z "$fmt" ]] && fmt="openpgp"
    case "$fmt" in
        ssh)     _gf_row "ssh signer"   "gpg.ssh.program" ;;
        x509)    _gf_row "x509 program" "gpg.x509.program" ;;
        *)       _gf_row "gpg program"  "gpg.program" ;;
    esac
    print -- ""

    # SSH / transport
    printf "${C_BOLD}${C_WHITE}Transport${C_RESET}\n"
    _gf_row "core.sshCmd"  "core.sshCommand"
    _gf_row "hooksPath"    "core.hooksPath"
    _gf_row "pull.rebase"  "pull.rebase"
    _gf_row "init.defBr"   "init.defaultBranch"
    print -- ""

    # Allowed signers file (for SSH commit verification)
    if [[ "$fmt" == "ssh" ]]; then
        printf "${C_BOLD}${C_WHITE}SSH verification${C_RESET}\n"
        _gf_row "allowedSigners" "gpg.ssh.allowedSignersFile"
        print -- ""
    fi

    unfunction _gf_get _gf_scope_color _gf_row 2>/dev/null
}
