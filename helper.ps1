#!/usr/bin/env pwsh

param(
    [string]$command,
    [switch]$force,
    [switch]$build
)

$ErrorActionPreference = "Stop"

$branch = git rev-parse --abbrev-ref HEAD
$time = $(Get-Date -Format 'hh:mmtt - dd/MM/yy')
$pkg = Get-Content -Raw package.json | ConvertFrom-Json

$repo = "Med-GPT/Med-GPT"
$api = "https://api.github.com/repos/$repo/releases/latest"
try {
    $res = Invoke-RestMethod -Uri $api -Headers @{
        "User-Agent"  = "benzaria"
    }
    Write-Host "Latest release found: $($res.tag_name)"
} catch {
    if ($_.Exception.Response.StatusCode.Value__ -eq 404) {
        Write-Warning "No latest release found for $repo"
        $res = @{ tag_name = "0.0.0" }
    } else {
        throw
    }
}

if ($force) { $_force = "--force" }

function git-push($msg, $force = $null) {
    Get-Content ../private.gpg | gpg --batch --yes --import

    git config user.name "Med-GPT"
    git config user.email "Med-GPT@users.noreply.github.com"
    git config user.signingkey B0F66F0DE1CFDEB3
    git remote add origin "https://x-access-token:$env:GH_TOKEN@github.com/$repo"
    
    git branch -M publish
    git commit -S -m "$msg"
    git push origin publish $force
    
    git push --delete origin $env:new
    git tag -s $env:new -m "$msg"
    git push origin $env:new
}

if ($IsWindows) { $os = 'Windows' }
elseif ($IsMacOS) { $os = 'MacOS' }
elseif ($IsLinux) { $os = 'Linux' }
else { $os = $env:os ? $env:os : 'Unknown' }

$env:new = "v$($pkg.version)"
$env:old = $res.tag_name

switch ($command) {

    deploy {
        if ($build) { 
            pnpm run build
            pnpm run make
        }

        New-Item -ItemType Directory -Force publish/.github/workflows 2>$null
        'node_modules' | Set-Content publish/.gitignore

        Copy-Item -Force -Recurse out/* publish
        Copy-Item -Force -Recurse .npmrc publish
        Copy-Item -Force -Recurse .sha256 publish
        Copy-Item -Force -Recurse dist publish/dist
        Copy-Item -Force -Recurse public.gpg publish
        Copy-Item -Force -Recurse helper.ps1 publish
        Copy-Item -Force -Recurse pnpm-lock.yaml publish
        Copy-Item -Force -Recurse forge.config.json publish
        Copy-Item -Force -Recurse .github/workflows/publish.yml publish/.github/workflows

        if (-not $env:GITHUB_CI) { break }

        Set-Location publish
        git init
        git add -A
        git-push "CI: Deploy Med-GPT $env:new" --force
    }

    prod-test {
        git checkout -b dev
        git add -A
        git commit -S -m "TEST: $env:new"
        git push origin test --force
        git checkout $branch
    }
    
    dev-push {
        git checkout -b dev
        git add -A
        git commit -S -m "DEV: Med-GPT $env:new"
        git push origin dev $_force
        git checkout $branch
    }

    prod-push {
        if ($env:new -eq $env:old -and -not $_force) { 
            Write-Error "Versions are the same! Please bump."
            break 
        }
        
        git add -A
        git commit -S 
        git push origin main $_force
    }

    publish {
        if (-not $env:GITHUB_CI) { break }
        
        Get-ChildItem 
        Get-ChildItem dist

        Set-Location dist
        $distFiles = Get-ChildItem ../*.gpg, *.dmg, *.nz, nsis-web/*.exe, nsis-web/*.7z | % { $_.FullName }
        Write-Host $distFiles

        if (-not $distFiles) {
            Write-Error "No files found in ./dist to publish"
            break
        }

        # git-push "Med-GPT[bot]" "CI: Package Med-GPT $env:new-$os"
        Write-Host Releasing $env:new
        gh release delete $env:new -y
        gh release create $env:new $distFiles --title "$env:new" #--notes ""
    }

    backup {
        git checkout -b backup
        git add -A
        git commit -m "backup - $branch - $time"
        git push origin backup $_force
        git checkout $branch
    }

    default { . $command }
}

# $appDir = "dist/$os"
# $appName = "med-gpt"

# if ($IsWindows) { $appName += '.exe' }
# $appPath = "$appDir/$appName"

# New-Item -ItemType Directory -Force "$appDir" 2>$null
# Copy-Item "$($(Get-Command node).Path)" "$appPath"

# try {
#     if ($IsMacOS) { codesign --remove-signature "$appPath" } 
#     if ($IsWindows) { signtool remove /s "$appPath" 2>$null }
# } catch {
#     Write-Error "Remove Sign Failed: $_"
#     break
# }

# if ($env:GITHUB_CI) { $appBlob = "make/app.blob" }
# else { $appBlob = "make/dist/app.blob" }

# $postjectArgs = @(
#     "$appPath"
#     "NODE_SEA_BLOB"
#     "$appBlob"
#     "--sentinel-fuse"
#     "NODE_SEA_FUSE_fce680ab2cc467b6e072b8b5df1996b2"
# )

# if ($IsMacOS) {
#     $postjectArgs += "--macho-segment-name"
#     $postjectArgs += "NODE_SEA"
# }

# try { pnpm postject @postjectArgs 2>$null}
# catch { 
#     Write-Error "PostJect Failed: $_" 
#     break
# }
