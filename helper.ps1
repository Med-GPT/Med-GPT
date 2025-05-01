#!/usr/bin/env pwsh

param(
    [string]$command,
    [switch]$force,
    [switch]$build
)

function git-push($user, $msg, $force = $null) {
    git config user.name "$user"
    git config user.email "$user@users.noreply.github.com"
    git commit -m "$msg"
    git branch -M publish
    git remote add git-action "https://x-access-token:$env:GH_TOKEN@github.com/Med-GPT/Med-GPT"
    git push git-action publish $force
}

if ($IsWindows) { $os = 'Windows' }
elseif ($IsMacOS) { $os = 'MacOS' }
elseif ($IsLinux) { $os = 'Linux' }
else { $os = $env:os ? $env:os : 'Unknown' }

$pkg = Get-Content -Raw package.json | ConvertFrom-Json
$ver = "v$($pkg.version)"

switch ($command) {

    'push' {
        if ($build) { pnpm run build }

        # New-Item -ItemType Directory -Force publish/out 2>$null
        # New-Item -ItemType Directory -Force publish/make 2>$null
        New-Item -ItemType Directory -Force publish/.github/workflows 2>$null

        # Remove-Item -Force -Recurse publish/dist/* 2>$null
        # Copy-Item -Force -Recurse make/dist/* publish/make
        # Copy-Item -Force -Recurse out/dist/* publish/out
        # Copy-Item -Force -Recurse dist/* publish/dist

        Copy-Item -Force -Recurse out/* publish 
        Copy-Item -Force -Recurse .npmrc publish
        Copy-Item -Force -Recurse .sha256 publish
        Copy-Item -Force -Recurse helper.ps1 publish
        Copy-Item -Force -Recurse pnpm-lock.yaml publish
        Copy-Item -Force -Recurse forge.config.json publish
        Copy-Item -Force -Recurse .github/workflows/package.yml publish/.github/workflows
        Copy-Item -Force -Recurse .github/workflows/publish.yml publish/.github/workflows

        "node_modules" | Set-Content publish/.gitignore

        if (-not $env:GITHUB_CI) { break }

        Set-Location publish
        git init
        git add .
        git-push "$env:GITHUB_ACTOR" "CI: Deploy Med-GPT $ver" --force
    }

    'push-test' {
        git add .
        git commit -m "Production test"
        git push origin main:test --force
    }

    'publish' {
        if (-not $env:GITHUB_CI) { break }

        Set-Location dist
        $distFiles = Get-ChildItem *.exe, *.dmg | ForEach-Object { $_.FullName }
        if (-not $distFiles) {
            Write-Error "No files found in ./dist to publish"
            break
        }

        gh release create $ver $distFiles --title "$ver" --notes "Release $ver"
    }

    'package' {
        if (-not $env:GITHUB_CI) { break }

        Set-Location dist
        $distFiles = Get-ChildItem *.exe, *.dmg | ForEach-Object { $_.FullName }
        if (-not $distFiles) {
            Write-Error "No files found in ./dist to publish"
            break
        }

        git add $distFiles
        git-push "Med-GPT[bot]" "CI: Package Med-GPT $ver-$os"
    }

    'backup' {
        $branch = git rev-parse --abbrev-ref HEAD
        $time   = $(Get-Date -FoRemove-Itemat 'hh:mmtt - dd/MM/yy')
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