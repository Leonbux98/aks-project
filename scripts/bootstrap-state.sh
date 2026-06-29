#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="rg-tfstate"
LOCATION="uksouth"
STORAGE_ACCOUNT="tfstate$(echo $RANDOM | md5sum | head -c 8)"
CONTAINER_NAME="tfstate"

echo "Creating resource group: $RESOURCE_GROUP"
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

echo "Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false \
  --min-tls-version TLS1_2

echo "Enabling versioning for state locking"
az storage account blob-service-properties update \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --enable-versioning true

echo "Creating blob container: $CONTAINER_NAME"
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --auth-mode login

echo ""
echo "Bootstrap complete. Now update terraform/backend.tf with:"
echo "  storage_account_name = \"$STORAGE_ACCOUNT\""
