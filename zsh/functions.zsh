fetch-kubernetes-secret() {
    name=$1
    namespace=$2
    if [[ -z "$name" || -z "$namespace"  ]]; then
        echo "Usage: fetch-kubernetes-secret [name] [namespace]"
        exit 1
    fi
    kubectl get secret -n "$namespace" "$name" -o json | jq '.data | map_values(@base64d)'
}
