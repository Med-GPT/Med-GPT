import{d as c,f as r,g as a,i as s,j as l}from"./lib/KRMSNYUO.js";import{app as w,session as g,nativeTheme as H}from"electron";import{BrowserWindow as b,WebContentsView as u,dialog as C}from"electron";import{join as W}from"path";var{base:m,llms:d,chat:v,redirect:p}=a,y={r:"4o",o:{show:!0,webPreferences:{contextIsolation:!1,nodeIntegration:!1,sandbox:!1,devTools:!1}},a:{webPreferences:{contextIsolation:!1,nodeIntegration:!1,sandbox:!1,devTools:!1}}},_=function(e,n){(this.webContents??this).on(e,n)},x=function(e,n,...t){this.i(e,()=>this.u(n,...t))};async function T(e,...n){await(this.webContents??this).executeJavaScript(typeof e=="string"?e:`(${e.toString()})(${n.join(",")})`)}function V(...e){let n=(t,i,h)=>{this.f++>3&&(C.showMessageBoxSync({type:"error",defaultId:0,cancelId:1,buttons:["Report","Ignore"],title:`Error: at Preload: ${i}`,message:`${h?.message?h.message:h}`})===0?s.wrn(new URL(`report/?error=${h?.message?h.message:h}`,"https://Med-GPT.github.io/")):s.err("closing...")),s.wrn("reloading...")};e.length?n(null,...e):this.i("preload-error",n)}function S(e=r.name){this.i("page-title-updated",n=>{n.preventDefault(),this.setTitle(e)})}function O(e){(this.webContents??this).setUserAgent(e)}function E(e){(this.webContents??this).session.webRequest.onHeadersReceived((n,t)=>{let{responseHeaders:i}=n;l(i,e),t({responseHeaders:i})})}function I(e){(this.webContents??this).session.webRequest.onBeforeSendHeaders((n,t)=>{let{requestHeaders:i}=n;l(i,e),t({requestHeaders:i})})}function P(e){(this.webContents??this).insertCSS(e)}function R(){(this.webContents??this).reload()}function f(e){let n=y;e&&l(n,e);let t=new u(n.a),i=new b(n.o);return t.webContents.loadFile(W(__dirname,"www/index.html")),i.webContents.loadURL((m&&d[n.r]?m+d[n.r]+v:p?p+"P2Vycm9yPWxsbXMtdW5kZWZpbmVk".e:s.trw("ZW52IHZhcmlhYmxlcyBhcmUgbm90IHNldCBwcm9wZXJseQ==".e)).t),$({win:i,view:t}),{win:i,view:t}}function $(e){Object.entries(e).forEach(([n,t])=>{t.webContents.parentName=n,t.webContents.parentObj=t,Object.assign(t,{i:_,u:T,x,n:R,f:0,T:E,C:I,E:P,p:O,g:S,l:V})})}import{platform as M}from"process";import{resolve as N}from"path";import{createHash as j}from"crypto";import{readFileSync as k}from"fs";import{resolve as B}from"path";var o={"get-file":e=>k(B(__dirname,e),"utf8"),"get-hash":e=>j("sha256").update(o["get-file"](e)).digest("hex"),"vrf-hash":(e,n)=>o["get-hash"](e)===n,"inject-css":function(e=r.style){this.insertCSS(o["get-file"](e))},"inject-raw-css":function(e){this.insertCSS(e)},show:function(e){o[`show-${e??this.parentName}`]()},hide:function(e){o[`hide-${e??this.parentName}`]()},reload:function(e){o[`reload-${e??this.parentName}`]()},"reload-all":()=>(win.n(),view.n()),"show-win":()=>win.show(),"hide-win":()=>win.hide(),"reload-win":()=>win.n(),"show-view":()=>(win.View=win.contentView,win.setContentView(view)),"hide-view":()=>win.setContentView(win.View),"reload-view":()=>view.n(),"close-win":()=>win.close(),"minimize-win":()=>win.minimize(),"maximize-win":()=>win.isMaximized()?win.unmaximize():win.maximize(),"preload-status":function(e,...n){(globalThis.k=e==="ok")||this.l(...n)},"load-file":async e=>{let n=await fetch(`${a.git.t}/${e}`);return n.ok||s.trw(`Failed to load ${e.split("/").shift()}: ${n.statusText}`),n.text()}};import{ipcMain as U}from"electron";Object.entries(o).forEach(([e,n])=>U.handle(e,(t,...i)=>n.call(t.sender,...i)));Object.assign(globalThis,{__appname:r.name,__dirname:import.meta.dirname,__filename:import.meta.filename});var z=N(__dirname,r.preload);w.whenReady().then(()=>{s("Electron is ready...");let e={r:"4o-mini",o:{show:!1,width:1200,height:700,title:__appname,titleBarStyle:"hidden",webPreferences:{session:g.fromPartition(`persist:${a.chat.t}`),preload:z}},a:{webPreferences:{session:g.fromPartition(`persist:${__appname}`)}}};Object.assign(globalThis,f(e)),H.themeSource=c.theme,win.g(),[win,view].forEach(n=>{n.l(),n.p(a.agent.t)})});w.on("window-all-closed",()=>{M!=="darwin"&&w.quit()});
//@ts-nocheck
/**
 * [0]: https://github.com/benzaria
 * [1]: https://github.com/Med-GPT
 * [2]: https://Med-GPT.github.io
 * [3]: https://github.com/Med-GPT/Med-GPT/releases
 * [4]: https://github.com/Med-GPT/Med-GPT/LICENSE
 * 
 * @name [**Med-GPT**][2]
 * @copyright [**benzaria**][0] and [**Med-GPT**][1] Foundation
 * @license [`CC BY-NC-ND 4.0`][4] 'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International'
 * @mixes *Medical* **GPT** + **RAG**
 * @GPT `Generative Pre-trained Transformer` by OpenAI
 * @RAG `Retrieval Augmented Generation` by benzaria
 * @version [1.5.2-beta.2][3]
 * @link [Home Page][2]
 */
let Hover_Me1 = 'Electron.App'

/**
 * jQuery JavaScript Library v3.7.1
 * https://jquery.com/
 *
 * Copyright OpenJS Foundation and other contributors  
 * Released under the MIT license  
 * https://jquery.org/license
 *
 * Date: 2023-08-28T13:37Z
 */
let Hover_Me2 = 'Module'