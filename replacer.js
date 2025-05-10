import { argv, execPath, exit } from 'process'
import { spawn } from 'child_process'
import { cp } from 'fs/promises'

let failCount = 0
const [, , script, asarOld, asarNew, main] = argv

await cp(asarNew, asarOld, { force: true })
    .then(() => spawnApp())
    .catch(() => reUpdate())

setTimeout(exit, 1e3)

function reUpdate() {
    if (main !== 'true') exit(1)
    if (failCount >= 3) exit(1)

    spawn(execPath, [script, asarOld, asarNew], { stdio: 'ignore' })
        .on('exit', code => code ? failCount++ : exit(0))
}

function spawnApp() {
    spawn(execPath, [asarOld], { detached: true, stdio: 'ignore' })
        .unref()
    exit(0)
}