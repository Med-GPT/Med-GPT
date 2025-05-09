#!/usr/bin/env pwsh

param(
    [string]$command,
    [switch]$force,
    [switch]$build
)

$repo = "Med-GPT/Med-GPT"
$api = "https://api.github.com/repos/$repo/releases/latest"
$res = Invoke-RestMethod -Uri $api -Headers @{ "User-Agent" = "benzaria" }
$pkg = Get-Content -Raw package.json | ConvertFrom-Json

function git-push($user, $msg, $force = $null) {
    git config user.name "$user"
    git config user.email "$user@users.noreply.github.com"
    git commit -m "$msg"
    git branch -M publish
    git remote add git-action "https://x-access-token:$env:GH_TOKEN@github.com/$repo"
    git push git-action publish $force
}

if ($IsWindows) { $os = 'Windows' }
elseif ($IsMacOS) { $os = 'MacOS' }
elseif ($IsLinux) { $os = 'Linux' }
else { $os = $env:os ? $env:os : 'Unknown' }

$new = "v$($pkg.version)"
$old = $res.tag_name

switch ($command) {

    push {
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
        Copy-Item -Force -Recurse helper.ps1 publish
        Copy-Item -Force -Recurse pnpm-lock.yaml publish
        Copy-Item -Force -Recurse forge.config.json publish
        Copy-Item -Force -Recurse .github/workflows/package.yml publish/.github/workflows
        Copy-Item -Force -Recurse .github/workflows/publish.yml publish/.github/workflows

        if (-not $env:GITHUB_CI) { break }

        Set-Location publish
        git init
        git add .
        git-push "$env:GITHUB_ACTOR" "CI: Deploy Med-GPT $new" --force
    }

    prod-test {
        git add .
        git commit -m "Production test $new"
        git push origin main:test --force
    }
    
    dev-push {
        git add .
        git commit -m "DEV: Med-GPT $new"
        git push origin main:dev $($force ? '--force' : $null)
    }

    prod-push {
        if ($new -eq $old) { 
            Write-Error "Versions are the same! Please bump."
            break 
        }

        git add .
        git commit -m "PROD: Med-GPT $new"
        git push origin main $($force ? '--force' : $null)
    }

    publish {
        if (-not $env:GITHUB_CI) { break }

        Set-Location dist
        $distFiles = Get-ChildItem -File | % { $_.FullName }
        if (-not $distFiles) {
            Write-Error "No files found in ./dist to publish"
            break
        }

        # git-push "Med-GPT[bot]" "CI: Package Med-GPT $new-$os"
        gh release create $new $distFiles --title "$new" --notes ""
    }

    backup {
        $branch = git rev-parse --abbrev-ref HEAD
        $time   = $(Get-Date -Format 'hh:mmtt - dd/MM/yy')
        $commit = "backup - $branch - $time"

        echo "commit -m $commit"
        echo "push ${branch}:backup"
        git add .
        git commit -m $commit
        git push origin ${branch}:backup $($force ? '--force' : $null)
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