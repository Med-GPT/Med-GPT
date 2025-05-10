var h=Object.create;var p=Object.defineProperty;var g=Object.getOwnPropertyDescriptor;var u=Object.getOwnPropertyNames;var w=Object.getPrototypeOf,b=Object.prototype.hasOwnProperty;var P=(e,t)=>()=>(t||e((t={exports:{}}).exports,t),t.exports),l=(e,t)=>{for(var r in t)p(e,r,{get:t[r],enumerable:!0})},T=(e,t,r,o)=>{if(t&&typeof t=="object"||typeof t=="function")for(let n of u(t))!b.call(e,n)&&n!==r&&p(e,n,{get:()=>t[n],enumerable:!(o=g(t,n))||o.enumerable});return e};var I=(e,t,r)=>(r=e!=null?h(w(e)):{},T(t||!e||!e.__esModule?p(r,"default",{value:e,enumerable:!0}):r,e));var k={};l(k,{deepMerge:()=>y,delay:()=>v,echo:()=>E,voidFn:()=>m});var s={ms:1,s:1e3,m:6e4,h:36e5,d:864e5,w:6048e5,M:2629746e3,Y:315576e5};function d(e,t=!1){if(typeof e=="string"){let o=e.match(/^\s*([-+]?\s*\d*\.?\d+)\s*(ms|[smhdwMY]?)\s*$/);if(o)return+o[1]*(s[o[2]]??1);let n=`Invalid time format ${e}, support: ${JSON.stringify(Object.keys(s))}`;if(!t)throw new Error(n);return console.error(n),-1}if(typeof e=="number")return console.warn("The Input was a number, no need for converting"),e;let r=`Input must be a string or number. Received: ${e}, with typeof ${typeof e}`;if(!t)throw new TypeError(r);return console.error(r),-1}var f=Object.fromEntries(Object.entries(s).map(([e])=>[e,{get(){return d(`${this}${e}`)}}]));function j(e){return Object.defineProperties(String.prototype,e??f),{}}j(f);var x=globalThis.window?.document!==void 0,v=(e="2".s)=>new Promise(t=>setTimeout(t,e)),m=()=>{},a={inf:[94,console.log],wrn:[93,console.warn],err:[91,console.error],trw:[35,(...e)=>{throw new Error(...e)}]},E=new Proxy(m,{apply:(e,t,r)=>console.log(...r),get(e,t){let[r,o]=a[t];return t in a?(...n)=>o(...x?n:n.map(c=>["string","number"].includes(typeof c)?`\x1B[${r}m${c}\x1B[0m`:c)):e}}),y=(e,t)=>{if(!e)return t;for(let r in t)t[r]&&!Array.isArray(t[r])&&typeof t[r]=="object"?((typeof e[r]!="object"||e[r]===null)&&(e[r]={}),e[r]=y(e[r],t[r])):t[r]!==void 0&&(e[r]=t[r]);return e},$={ub:e=>btoa(e),bu:e=>atob(e),uh:e=>Array.from(new TextEncoder().encode(e)).map(t=>t.toString(16).padStart(2,"0")).join(""),hu:e=>new TextDecoder().decode(new Uint8Array(e.match(/.{1,2}/g)?.map(t=>parseInt(t,16))||[]))},i=e=>function(){return this?$[e](this):void 0},O=()=>function(){return this.replace(/<br\s*\/?>/g,`
`).replace(/<\/?[^>]+(>|$)/g,"")},M=()=>function(){return this.charAt(0).toUpperCase()+this.slice(1)},S={e:{get:i("bu")},y:{get:i("ub")},t:{get:i("hu")},v:{get:i("uh")},b:{get:O()},c:{get:M()}};Object.defineProperties(String.prototype,S);import C from"../settings.json"with{type:"json"};import F from"../renderer.json"with{type:"json"};import J from"../package.json"with{type:"json"};import A from"../env.json"with{type:"json"};A.base=[!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0+!0]+[0]+[!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0]+[!0+!0+!0]+"a"+[!0+!0]+"f"+[!0+!0]+"f"+[!0+!0+!0+!0+!0+!0]+[!0+!0+!0]+[!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0]+[1]+[!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0+!0+!0+!0]+[0]+[!0+!0+!0+!0+!0+!0+!0]+[!0+!0+!0+!0]+[!0+!0]+"true"[!0+!0+!0]+[!0+!0+!0+!0+!0+!0]+[!0+!0+!0]+[!0+!0+!0+!0+!0+!0]+"f"+[!0+!0+!0+!0+!0+!0]+([][[]]+[])[!0+!0]+[!0+!0]+"f"+[!0+!0+!0]+"f";export{P as a,l as b,I as c,m as d,E as e,y as f,k as g,C as h,F as i,J as j,A as k};
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