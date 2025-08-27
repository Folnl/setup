#!/usr/bin/env fish

function check_aws_cli
    if type -q aws
        echo "✅ AWS CLI já está instalado: (aws --version)"
        aws --version
    else
        echo "❌ AWS CLI não está instalado."
    end
end

function check_terraform
    if type -q terraform
        echo "✅ Terraform já está instalado: (terraform -version)"
        terraform -version
    else
        echo "❌ Terraform não está instalado."
    end
end

function configure_aws
    echo "🔑 Configurando AWS CLI..."
    read -P "AWS Access Key ID: " aws_access_key
    read -P "AWS Secret Access Key: " aws_secret_key
    read -P "Região padrão (ex: us-east-1): " aws_region

    mkdir -p ~/.aws

    echo "[default]
aws_access_key_id = $aws_access_key
aws_secret_access_key = $aws_secret_key
" > ~/.aws/credentials

    echo "[default]
region = $aws_region
output = json
" > ~/.aws/config

    echo "✅ AWS CLI configurado!"
end

# ==========================
# Execução
# ==========================
check_aws_cli
check_terraform
configure_aws

echo ""
echo "⚡️ Tudo pronto (se os binários estiverem instalados)!"
echo " - AWS CLI: (aws --version)"
echo " - Terraform: (terraform -version)"
