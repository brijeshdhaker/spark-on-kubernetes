resourceGroupName="cloud-shell-storage-centralindia"
storageAccountName="csg100320025a786393"

# This command assumes you have logged in with az login
httpEndpoint=$(az storage account show \
    --resource-group "cloud-shell-storage-centralindia" \
    --name "csg100320025a786393" \
    --query "primaryEndpoints.file" --output tsv | tr -d '"')
# httpEndpoint=https://csg100320025a786393.file.core.windows.net/
smbPath=$(echo $httpEndpoint | cut -c7-${#httpEndpoint})
fileHost=$(echo $smbPath | tr -d "/")

nc -zvw3 csg100320025a786393.file.core.windows.net 445