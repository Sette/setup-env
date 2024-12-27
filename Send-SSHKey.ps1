# Path to your private SSH key
$PrivateKeyPath = "C:\Users\bruno\.ssh\id_ed25519"
$SetupScript = "C:\Users\bruno\git\Setup-Kaggle-env\setup_kaggle.sh"

# Remote destination (Kaggle)
$RemoteHost = "Kaggle"
$RemoteSSHDir = "/root/.ssh"
$RemotePrivateKeyPath = "$RemoteSSHDir/id_ed25519"
$RemoteSetupScriptPath = "$RemoteSSHDir/setup_kaggle.sh"

# Ensure the private key exists
if (-Not (Test-Path -Path $PrivateKeyPath)) {
    Write-Error "Private key not found at $PrivateKeyPath. Please generate an SSH key pair using 'ssh-keygen' or specify the correct path."
    exit 1
}

# Debug: Display file paths
Write-Host "Private key path: $PrivateKeyPath"
Write-Host "Remote host alias: $RemoteHost"
Write-Host "Remote destination path: ${RemoteHost}:${RemotePrivateKeyPath}"

# Copy the private key to the remote host
Write-Host "Creating paths .ssh and git ${RemoteHost}..."
ssh ${RemoteHost} "mkdir ${RemoteSSHDir} && mkdir /root/git"

# Copy the private key to the remote host
Write-Host "Copying private key to ${RemoteHost}:${RemotePrivateKeyPath}..."
scp $PrivateKeyPath "${RemoteHost}:${RemotePrivateKeyPath}"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to copy private key to ${RemoteHost}:${RemotePrivateKeyPath}"
    exit 1
}

# Copy the private key to the remote host
Write-Host "Copying setup file to ${RemoteHost}:${RemoteSetupScriptPath}..."
scp $SetupScript "${RemoteHost}:${RemoteSetupScriptPath}"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to copy setup script to ${RemoteHost}:${RemotePrivateKeyPath}"
    exit 1
}

# Set permissions on the remote host
Write-Host "Setting permissions for the private key on ${RemoteHost}..."
ssh ${RemoteHost} "chmod 700 ${RemoteSSHDir} && chmod 600 ${RemotePrivateKeyPath}"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to set permissions on ${RemoteHost}"
    exit 1
}

# Set permissions for script on the remote host
Write-Host "Setting permissions for the remote script and run then ${RemoteHost}..."
ssh ${RemoteHost} "chmod +x ${RemoteSetupScriptPath} && sh ${RemoteSetupScriptPath} &"


if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to set permissions on ${RemoteHost}"
    exit 1
}
Write-Host "Private key successfully copied to ${RemoteHost}:${RemotePrivateKeyPath}"