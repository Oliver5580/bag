/* ================================================================
   浮生仙途 · 人生模拟器（修仙篇）
   ================================================================ */
'use strict';

/* ---------------- 工具 ---------------- */
const $ = id => document.getElementById(id);
const R = Math.random;
const ri = (a, b) => a + Math.floor(R() * (b - a + 1));
const pick = a => a[Math.floor(R() * a.length)];
const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
const sleep = ms => new Promise(r => setTimeout(r, ms));
const fmt = n => {
  n = Math.round(n);
  const neg = n < 0, m = Math.abs(n);
  const s = m >= 10000 ? (m / 10000).toFixed(m >= 100000 ? 0 : 1) + '万' : String(m);
  return (neg ? '-' : '') + s;
};
function weightedPick(list, wf) {
  let tot = 0;
  for (const it of list) tot += wf(it);
  let r = R() * tot;
  for (const it of list) { r -= wf(it); if (r <= 0) return it; }
  return list[list.length - 1];
}

/* ---------------- 基础数据 ---------------- */
const TALENTS = {
  daoti : { name:'天生道体', desc:'悟性超凡，举一反三。悟性+15，学习与修炼效率大幅提升，生病较少。', mods:{intl:15}, studyMul:1.4, cultMul:1.25, sickMul:0.6 },
  tiruo : { name:'先天体弱', desc:'自幼药罐不离手，气血-15，生病概率大增；但久病磨砺心志，悟性+8。', mods:{hp:-15,intl:8}, sickMul:3.2 },
  lingxi: { name:'八面玲珑', desc:'天生交际圣体，人见人爱。魅力+15，社交收益翻倍，更易邂逅良缘。', mods:{cha:15}, socMul:2 },
  jianxin:{ name:'剑心通明', desc:'剑骨天成，体魄过人。精力+15，历练战斗占尽上风，修炼速度略有增益。', mods:{sta:15}, cultMul:1.1, fightBonus:0.25 },
};
const ORIGINS = {
  shijia: { name:'修仙世家', desc:'生于仙门世家，家传功法、灵石充裕。金钱+5000，悟性+8，每年获家族资源滋养修为。', money:5000, mods:{intl:8}, allow:400 },
  tong  : { name:'凡人富户', desc:'凡俗富户之家，衣食无忧，父母安康。金钱+2000，家境殷实更易遇到好事。', money:2000, allow:150 },
  pin   : { name:'山村贫户', desc:'山村贫户，家徒四壁。金钱+80，却因此吃苦耐劳：精力+6，机缘更念旧情。', money:80, mods:{sta:6}, allow:30 },
};
const ROOTS = {
  tian: { name:'天灵根', mul:1.8, bp:0.18, w:5,  desc:'万中无一，修炼一日千里' },
  zhen: { name:'真灵根', mul:1.35, bp:0.07, w:15, desc:'上佳资质，宗门争抢之才' },
  fan : { name:'凡灵根', mul:1.0, bp:0.0,  w:50, desc:'寻常资质，勤能补拙' },
  wei : { name:'伪灵根', mul:0.7, bp:-0.1, w:30, desc:'驳杂愚钝，事倍功半' },
};
const REALMS = [
  { name:'凡人', need:0,    life:80  },
  { name:'炼气', need:100,  life:95  },
  { name:'筑基', need:300,  life:125 },
  { name:'金丹', need:700,  life:190 },
  { name:'元婴', need:1400, life:300 },
  { name:'化神', need:2400, life:450 },
  { name:'渡劫', need:4000, life:700 },
  { name:'大乘', need:6000, life:1000 },
];
const ASCEND_NEED = 8000;
const SALARY = {
  '杂役弟子':100,'外门弟子':300,'内门弟子':800,'真传弟子':2000,'长老':5000,
  '书院学子':0,'账房':400,'掌柜':1200,'县令':2200,'书院学士':150,'游方散修':200,'学徒':150
};
const HEROINES = [
  { pic:0, desc:'白衣少女', style:'黑发雪肤，温婉可人', aura:'#f0a0c8' },
  { pic:1, desc:'红衣女将', style:'红缨烈甲，飒爽英气', aura:'#ff9aa8' },
  { pic:2, desc:'银发仙子', style:'白衣胜霜，清冷出尘', aura:'#bfe8ff' },
  { pic:3, desc:'紫衣妖姬', style:'眉间朱砂，媚眼如丝', aura:'#c9a2ff' },
  { pic:4, desc:'绿裙药师', style:'药囊在腰，笑靥如花', aura:'#a8e8b0' },
  { pic:5, desc:'金袍女帝', style:'凤冠垂珠，气度天成', aura:'#ffd97a' },
  { pic:6, desc:'黑衣女侠', style:'劲装红绸，眼神清冽', aura:'#9fb8d8' },
];
/* 女主玩家（性别=女）遇到的男NPC池 */
const MALE_IDS = [
  { desc:'青衫剑客', style:'仗剑江湖，眉目如画' },
  { desc:'白衣公子', style:'温文尔雅，如芝兰玉树' },
  { desc:'黑袍游侠', style:'冷面热心，行侠仗义' },
  { desc:'金冠公子', style:'锦衣华服，贵气天成' },
  { desc:'儒衫书生', style:'眉目清朗，书卷盈袖' },
  { desc:'玄衣刀客', style:'刀眉入鬓，锋芒内敛' },
];
function meetPerson() {
  const m = pick(MALE_IDS);
  return { name: randName(), desc: m.desc, style: m.style, aura: '#8fb8f0', pic: null, look: ri(0, MALE_LOOKS.length - 1) };
}
/* 剧情邂逅：男主玩家命中的女主按索引固定（姓名每世随机，邂逅一次后固定）；女主玩家随机男NPC */
function encWho(idx) {
  if (s.gender === 'f') return meetPerson();
  if (!s.flags['who' + idx]) s.flags['who' + idx] = { ...HEROINES[idx], name: randName() };
  return s.flags['who' + idx];
}
const metFlag = idx => !!s.flags['met' + idx];
const setMet = idx => { s.flags['met' + idx] = true; };
/* 初始资质：出身与天赋占用点数，剩余由「流派」一键分配（参照市面修仙模拟器的简化做法） */
const ALLOC_BASE = { sta: 80, intl: 40, cha: 40, gift: 10 };
const ALLOC_CAP  = { sta: 12, intl: 18, cha: 18, gift: 15 };
const ALLOC_POINTS = 40;
const ALLOC_LABEL = { sta:'精力', intl:'悟性', cha:'魅力', gift:'灵性' };
const BUILDS = {
  jian: { name: '剑修', tip: '精力与灵性见长，以武入道，行走山川更稳', w: { sta: .42, gift: .30, intl: .16, cha: .12 } },
  shu:  { name: '书修', tip: '悟性超群，谋定后动，悟性一路高歌',     w: { intl: .45, gift: .20, sta: .20, cha: .15 } },
  qing: { name: '情修', tip: '魅力过人，处处逢缘，仙缘情缘两不误',   w: { cha: .45, intl: .20, sta: .15, gift: .20 } },
  jun:  { name: '均衡', tip: '四维兼修，稳中求进，不惧命运刁难',     w: { sta: .28, intl: .26, cha: .26, gift: .20 } },
  rand: { name: '天命随机', tip: '不问西东，全凭气运',               w: null },
};
/* 出身与天赋同样消耗点数：越强越贵，随机天命不耗点 */
const ORIGIN_COST = { shijia:12, tong:5, pin:0 };
const TALENT_COST = { daoti:10, lingxi:6, jianxin:6, tiruo:0 };
let alloc = { sta: 0, intl: 0, cha: 0, gift: 0 };
const originCost = () => ORIGIN_COST[($('in-origin') && $('in-origin').value) || 'rand'] || 0;
const talentCost = () => TALENT_COST[($('in-talent') && $('in-talent').value) || 'rand'] || 0;
const allocLeft = () => ALLOC_POINTS - originCost() - talentCost() - (alloc.sta + alloc.intl + alloc.cha + alloc.gift);
const SURN = ['林','叶','苏','萧','云','秦','陆','沈','顾','白','洛','楚','慕','姬','凤','温','裴','谢','江','宋'];
const GIVEN = ['尘','寒','雪','月','风','云','天','羽','烟','澜','渊','曦','霜','歌','离','昭','珩','清','玄','晏','遥','晚','行','舟','岫','蘅','之','淮'];
const randName = () => pick(SURN) + pick(GIVEN) + (R() < 0.4 ? pick(GIVEN) : '');
const CALM_LINES = ['岁末围炉，无事发生。','山中无岁月，静度一年。','这一年风平浪静。','灵茶一盏，闲话桑麻。','无事，读书扫地，看云起云落。'];
const FX_LABEL = { hp:'气血', mood:'道心', money:'灵石', intl:'悟性', cha:'魅力', sta:'精力', cult:'修为', karma:'善恶', gift:'灵性' };
/* ===== 三维枯竭：低于阈值即触发惩罚 ===== */
const DRAIN = { hp:20, mood:15, sta:15 };
function drainWarns() {
  const w = [];
  if (s.sta < DRAIN.sta) w.push('力竭');
  if (s.mood < DRAIN.mood) w.push('心魔');
  if (s.hp < DRAIN.hp) w.push('病危');
  return w;
}
/* 各行为在枯竭状态下的效率折损 */
function drainMul(act) {
  let mul = 1;
  if (s.sta < DRAIN.sta && (act === 'cultivate' || act === 'study' || act === 'work')) mul *= 0.5;
  if (s.mood < DRAIN.mood && (act === 'cultivate' || act === 'study' || act === 'social')) mul *= 0.7;
  if (s.hp < DRAIN.hp && (act === 'cultivate' || act === 'work' || act === 'train')) mul *= 0.6;
  return mul;
}
function drainWarnHtml() {
  const w = [];
  if (s.sta < DRAIN.sta) w.push('<b>力竭</b>修炼／学习／打工收益减半，持续伤身');
  if (s.mood < DRAIN.mood) w.push('<b>心魔</b>修行社交迟滞，修为逐年后退');
  if (s.hp < DRAIN.hp) w.push('<b>病危</b>走火入魔概率激增，随时可能殒命');
  if (!w.length) return '';
  return `<div class="drain-warn">⚠ ${w.join('<br>⚠ ')}</div>`;
}

/* ---------------- 立绘 SVG ---------------- */
let SVG_UID = 0;
function uniqIds(str, names) {
  const u = 'U' + (++SVG_UID);
  return str
    .replace(new RegExp('id="(' + names.join('|') + ')"', 'g'), (m, id) => `id="${id}_${u}"`)
    .replace(new RegExp('url\\(#(' + names.join('|') + ')\\)', 'g'), (m, id) => `url(#${id}_${u})`);
}
const PORTRAIT_IDS = ['pImgGlow','pImgVig','pImgClip'];
const PORTRAIT_SRC = {
  m: 'assets/portrait-m.png',
  f: ['assets/portrait-f.png', 'assets/portrait-f-red.png', 'assets/portrait-f-blue.png', 'assets/portrait-f-purple.png', 'assets/portrait-f-green.png', 'assets/portrait-f-gold.png', 'assets/portrait-f-dark.png']
};
/* 男主「每一世随机建模」：
   优先用真实立绘 assets/portrait-m-<n>.png（美术提供，可选）；
   没有时程序化烘焙 8 套「镜像 × 构图 × 色调」变体，视觉效果各不相同；
   最后兜底原图。 */
const MALE_LOOKS = [
  { name: '墨金', flip: false, close: false, filter: 'saturate(1)' },
  { name: '玄青', flip: true,  close: false, filter: 'hue-rotate(165deg) saturate(.9)' },
  { name: '绯焰', flip: false, close: true,  filter: 'hue-rotate(305deg) saturate(1.08)' },
  { name: '霜白', flip: true,  close: true,  filter: 'saturate(.22) brightness(1.16)' },
  { name: '黛紫', flip: false, close: true,  filter: 'hue-rotate(235deg) saturate(.85)' },
  { name: '鎏银', flip: true,  close: false, filter: 'sepia(.55) hue-rotate(175deg) saturate(.65) brightness(1.08)' },
  { name: '翡翠', flip: true,  close: true,  filter: 'hue-rotate(85deg) saturate(.78)' },
  { name: '烟灰', flip: false, close: false, filter: 'saturate(.4) brightness(1.06)' },
];
const MALE_VARIANT_URLS = new Array(MALE_LOOKS.length).fill(null);
const lookFilter = i => (MALE_LOOKS[i] || MALE_LOOKS[0]).filter;
const getMaleUrl = i => MALE_VARIANT_URLS[i || 0] || PORTRAIT_SRC.m;
/* 加载失败：重试一次，仍失败则用主题占位像，绝不留空 */
const FALLBACK_AVATAR = 'data:image/svg+xml;utf8,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 400"><defs><radialGradient id="g" cx="50%" cy="30%" r="80%"><stop offset="0%" stop-color="#3a2f55"/><stop offset="100%" stop-color="#12101f"/></radialGradient></defs><rect width="300" height="400" fill="url(#g)"/><text x="150" y="238" font-size="110" font-family="KaiTi,STKaiti,serif" fill="#d8b45a" text-anchor="middle" opacity=".85">仙</text></svg>');
function maleImgFail(el) {
  if (el.dataset.retried) { el.src = FALLBACK_AVATAR; return; }
  el.dataset.retried = '1';
  setTimeout(() => { el.src = el.getAttribute('src'); }, 500);
}
function portraitImg(aura, src, cls) {
  /* 不用懒加载：面板头像在部分 WebView 下懒加载会延迟或不刷新 */
  return `<div class="pframe ${cls || ''}" style="--aura:${aura}">
    <img src="${src}" alt="" decoding="async" onerror="maleImgFail(this)">
    <div class="pframe-glow"></div>
    <div class="pframe-vig"></div>
  </div>`;
}
function portraitM(aura, look) { return portraitImg(aura, getMaleUrl(look), 'm'); }
let maleBaseReady = null;
function maleBaseImage() {
  if (!maleBaseReady) {
    maleBaseReady = new Promise((res, rej) => {
      const im = new Image();
      im.onload = () => res(im);
      im.onerror = rej;
      im.src = PORTRAIT_SRC.m;
    });
  }
  return maleBaseReady;
}
function bakeMaleVariants() {
  maleBaseImage().then(im => {
    let done = 0;
    const finish = () => {
      done++;
      if (done >= MALE_LOOKS.length) {
        if (phase === 'start') renderPreview();
        if (s && !$('scr-game').classList.contains('hidden')) renderPanel();
      }
    };
    MALE_LOOKS.forEach((lk, i) => {
      try {
        const cv = document.createElement('canvas');
        cv.width = 1024; cv.height = 1024;
        const cx = cv.getContext('2d');
        /* 半身构图裁掉顶部约 14% 白底；特写构图取面部区域 */
        const r = lk.close ? { x: 150, y: 200, w: 690 } : { x: 70, y: 140, w: 884 };
        cx.save();
        if (lk.flip) { cx.translate(1024, 0); cx.scale(-1, 1); }
        try { cx.filter = lk.filter; } catch (e) {}
        cx.drawImage(im, r.x, r.y, r.w, r.w, 0, 0, 1024, 1024);
        cx.restore();
        /* 用 blob url 而非 data url：浏览器可缓存解码结果，面板高频重绘不会反复解码大图 */
        cv.toBlob(bl => {
          MALE_VARIANT_URLS[i] = bl ? URL.createObjectURL(bl)
            : (() => { try { return dataUrlToBlobUrl(cv.toDataURL('image/webp', .9)); } catch (e) { return PORTRAIT_SRC.m; } })();
          finish();
        }, 'image/webp', .9);
      } catch (e) { finish(); }
    });
  }).catch(() => {});
}
function dataUrlToBlobUrl(dataUrl) {
  try {
    const parts = dataUrl.split(',');
    const mime = (parts[0].match(/data:(.*?);base64/) || [])[1] || 'image/png';
    const bin = atob(parts[1]);
    const arr = new Uint8Array(bin.length);
    for (let i = 0; i < bin.length; i++) arr[i] = bin.charCodeAt(i);
    return URL.createObjectURL(new Blob([arr], { type: mime }));
  } catch (e) { return dataUrl; }
}
function probeMaleOverrides() {
  for (let i = 0; i < MALE_LOOKS.length; i++) {
    const im = new Image();
    im.onload = () => {
      if (im.naturalWidth > 1) { MALE_VARIANT_URLS[i] = `assets/portrait-m-${i}.png`; if (phase === 'start') renderPreview(); }
    };
    im.onerror = () => {};
    im.src = `assets/portrait-m-${i}.png`;
  }
}
function portraitF(aura, variant) { return portraitImg(aura, PORTRAIT_SRC.f[variant] || PORTRAIT_SRC.f[0]); }

function portraitSVG(s) {
  const aura = ['#8a93b8','#9fd7ff','#7fe0ff','#ffd97a','#c9a2ff','#ff9aa8','#ffb36b','#fff3b0'][s.realm] || '#d8b45a';
  if (s.gender === 'm') return { svg: portraitM(aura, s.look || 0), aura };
  // 女主立绘随境界进阶：凡人~筑基 黑发蝴蝶结 / 金丹~元婴 红金战袍 / 化神以上 银白仙装
  const variant = s.realm >= 5 ? 2 : (s.realm >= 3 ? 1 : 0);
  return { svg: portraitF(aura, variant), aura };
}

/* ---------------- 场景配图 SVG ---------------- */
const SCENE_PAL = {
  family:    ['#33254d','#584a78','#e8dcb8'],
  school:    ['#1d2b45','#3a5578','#f0d9a8'],
  sect:      ['#16233d','#3d5a7a','#dfe8f2'],
  romance:   ['#3a1f33','#6b3a55','#f0b8d0'],
  wedding:   ['#421422','#8a2438','#ffd2c2'],
  battle:    ['#3a1420','#6e2430','#ff9a8a'],
  treasure:  ['#1e3320','#3f6e3a','#c9f2a8'],
  misfortune:['#101018','#26263a','#b8b8d0'],
  death:     ['#0c0c14','#1c1c2e','#c8ccd8'],
  western:   ['#1a2340','#3a4a7e','#bcd0f2'],
  cultivate: ['#0f202e','#1f4a5e','#a8f0ff'],
  festival:  ['#331b12','#6e3a1f','#ffd08a'],
};
function sceneSVG(kind) {
  const p = SCENE_PAL[kind] || SCENE_PAL.family;
  const sil = 'rgba(8,10,20,.92)';
  let fg = '';
  switch (kind) {
    case 'family': fg = `
      <g fill="${sil}"><polygon points="285,160 385,160 335,112"/><rect x="298" y="160" width="74" height="80"/>
      <rect x="322" y="192" width="26" height="48" fill="rgba(255,214,140,.55)"/></g>
      <g fill="${sil}"><rect x="60" y="170" width="10" height="70"/><circle cx="65" cy="150" r="34"/><circle cx="40" cy="168" r="22"/><circle cx="92" cy="166" r="24"/></g>`; break;
    case 'school': fg = `
      <g fill="${sil}"><rect x="150" y="176" width="120" height="14" rx="4"/><rect x="160" y="160" width="100" height="14" rx="4" fill="rgba(20,24,44,.95)"/>
      <rect x="168" y="144" width="84" height="14" rx="4" fill="${sil}"/><circle cx="288" cy="182" r="8"/><rect x="284" y="150" width="8" height="32"/></g>`; break;
    case 'sect': fg = `
      <g fill="${sil}"><polygon points="150,150 290,150 220,118"/><rect x="176" y="150" width="88" height="16"/>
      <polygon points="162,112 278,112 220,84"/><rect x="184" y="128" width="72" height="24"/>
      <polygon points="176,80 264,80 220,56"/><rect x="196" y="92" width="48" height="20"/>
      <rect x="212" y="40" width="16" height="20"/></g>`; break;
    case 'romance': fg = `
      <g fill="${sil}"><circle cx="192" cy="130" r="15"/><path d="M170,240 L172,178 Q176,150 192,150 Q208,150 212,178 L214,240 Z"/>
      <circle cx="248" cy="134" r="14"/><path d="M228,240 L230,182 Q234,152 248,152 Q262,152 266,182 L268,240 Z"/></g>
      <path d="M300,120 c0,-10 14,-10 14,0 c0,-10 14,-10 14,0 c0,10 -14,18 -14,26 c0,-8 -14,-16 -14,-26 Z" fill="rgba(240,150,180,.85)"/>`; break;
    case 'wedding': fg = `
      <g stroke="rgba(20,8,12,.9)" stroke-width="2" fill="none"><line x1="0" y1="34" x2="420" y2="26"/></g>
      ${[60,140,220,300,380].map(x => `<g><line x1="${x}" y1="30" x2="${x}" y2="52" stroke="rgba(20,8,12,.9)" stroke-width="2"/>
        <ellipse cx="${x}" cy="72" rx="17" ry="21" fill="rgba(210,60,70,.92)"/><rect x="${x - 8}" y="48" width="16" height="7" rx="3" fill="#d8b45a"/>
        <line x1="${x}" y1="93" x2="${x}" y2="112" stroke="#d8b45a" stroke-width="2"/></g>`).join('')}`; break;
    case 'battle': fg = `
      <g transform="translate(180,180) rotate(28)"><rect x="-9" y="-120" width="18" height="240" rx="8" fill="${sil}"/></g>
      <g transform="translate(250,180) rotate(-28)"><rect x="-9" y="-120" width="18" height="240" rx="8" fill="${sil}"/></g>
      <circle cx="215" cy="120" r="5" fill="rgba(255,220,140,.9)"/><circle cx="240" cy="90" r="4" fill="rgba(255,220,140,.8)"/><circle cx="196" cy="100" r="3.4" fill="rgba(255,220,140,.8)"/>`; break;
    case 'treasure': fg = `
      <g fill="${sil}"><rect x="160" y="150" width="110" height="66" rx="8"/><path d="M154,150 Q215,108 276,150 Z"/></g>
      <g><circle cx="215" cy="128" r="26" fill="rgba(246,221,148,.22)"/><circle cx="215" cy="128" r="10" fill="rgba(246,221,148,.85)"/></g>
      <circle cx="300" cy="90" r="9" fill="rgba(127,224,190,.75)"/><circle cx="130" cy="76" r="7" fill="rgba(127,224,190,.65)"/><circle cx="330" cy="140" r="6" fill="rgba(246,221,148,.7)"/>`; break;
    case 'misfortune': fg = `
      <polyline points="215,0 180,74 212,74 158,158" fill="none" stroke="rgba(240,230,140,.9)" stroke-width="5" stroke-linejoin="round"/>
      ${Array.from({length: 12}, (_, i) => `<line x1="${20 + i * 34}" y1="${10 + (i % 3) * 22}" x2="${8 + i * 34}" y2="${54 + (i % 3) * 22}" stroke="rgba(150,160,210,.28)" stroke-width="2"/>`).join('')}`; break;
    case 'death': fg = `
      <g fill="${sil}"><path d="M188,230 L188,140 Q188,112 215,112 Q242,112 242,140 L242,230 Z"/>
      <line x1="130" y1="230" x2="130" y2="176"/><line x1="140" y1="230" x2="140" y2="182"/><line x1="120" y1="230" x2="120" y2="182"/>
      <circle cx="298" cy="196" r="16" fill="none" stroke="${sil}" stroke-width="6"/></g>`; break;
    case 'western': fg = `
      <g fill="${sil}"><rect x="150" y="120" width="120" height="120"/>
      <rect x="120" y="150" width="34" height="90"/><rect x="266" y="150" width="34" height="90"/>
      <polygon points="114,150 154,150 134,108"/><polygon points="260,150 300,150 280,108"/><polygon points="144,120 276,120 210,72"/>
      <rect x="196" y="190" width="28" height="50" fill="rgba(255,214,140,.5)"/>
      <line x1="280" y1="108" x2="280" y2="86"/><polygon points="280,86 306,92 280,98"/></g>`; break;
    case 'cultivate': fg = `
      <g fill="${sil}"><polygon points="60,240 230,240 145,96"/><polygon points="240,240 420,240 340,120"/></g>
      <g fill="${sil}"><circle cx="145" cy="86" r="10"/><path d="M125,124 Q127,100 145,100 Q163,100 165,124 Q145,132 125,124 Z"/></g>
      <ellipse cx="145" cy="112" rx="46" ry="14" fill="none" stroke="rgba(168,240,255,.5)" stroke-width="2"/>
      <ellipse cx="145" cy="112" rx="66" ry="20" fill="none" stroke="rgba(168,240,255,.3)" stroke-width="2"/>`; break;
    case 'festival': fg = `
      <g stroke="rgba(20,10,8,.9)" stroke-width="2" fill="none"><path d="M0,30 Q210,64 420,30" /></g>
      ${[50,130,210,290,370].map(x => `<g><line x1="${x}" y1="${30 + Math.round(Math.abs(x - 210) * -0.08) + 34}" x2="${x}" y2="${30 + Math.round(Math.abs(x - 210) * -0.08) + 56}" stroke="rgba(20,10,8,.9)" stroke-width="2"/>
        <ellipse cx="${x}" cy="${30 + Math.round(Math.abs(x - 210) * -0.08) + 78}" rx="16" ry="20" fill="rgba(235,150,60,.92)"/></g>`).join('')}
      <circle cx="330" cy="70" r="3" fill="rgba(255,220,140,.9)"/><circle cx="345" cy="52" r="2.4" fill="rgba(255,220,140,.8)"/><circle cx="318" cy="46" r="2.2" fill="rgba(255,220,140,.8)"/>`; break;
    default: fg = '';
  }
  const S = `<svg viewBox="0 0 420 240" preserveAspectRatio="xMidYMid slice" xmlns="http://www.w3.org/2000/svg">
<defs><linearGradient id="scSky" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="${p[0]}"/><stop offset="100%" stop-color="${p[1]}"/></linearGradient>
<radialGradient id="scMoon"><stop offset="0%" stop-color="${p[2]}" stop-opacity=".95"/><stop offset="100%" stop-color="${p[2]}" stop-opacity="0"/></radialGradient>
<linearGradient id="scFade" x1="0" y1="0" x2="0" y2="1"><stop offset="55%" stop-color="rgba(6,7,13,0)"/><stop offset="100%" stop-color="rgba(6,7,13,.8)"/></linearGradient></defs>
<rect width="420" height="240" fill="url(#scSky)"/>
<circle cx="340" cy="52" r="46" fill="url(#scMoon)"/><circle cx="340" cy="52" r="17" fill="${p[2]}" opacity=".92"/>
<polygon points="0,240 0,168 80,104 170,180 260,120 350,186 420,140 420,240" fill="rgba(12,15,30,.75)"/>
${fg}
<circle cx="70" cy="60" r="2" fill="rgba(246,221,148,.8)"/><circle cx="120" cy="40" r="1.6" fill="rgba(246,221,148,.7)"/><circle cx="255" cy="36" r="1.8" fill="rgba(246,221,148,.7)"/>
<rect width="420" height="240" fill="url(#scFade)"/></svg>`;
  return uniqIds(S, ['scSky','scMoon','scFade']);
}

/* ---------------- 女主 CG 场景 ---------------- */
const cgDot = (x, y, r, c, o = .85) => `<circle cx="${x}" cy="${y}" r="${r}" fill="${c}" opacity="${o}"/>`;
const cgPetal = (x, y, s, c, rot, o = .85) => `<ellipse cx="${x}" cy="${y}" rx="${s}" ry="${s * .55}" fill="${c}" opacity="${o}" transform="rotate(${rot} ${x} ${y})"/>`;
const cgLantern = (x, y, r, c) => `<g class="cg-sway"><line x1="${x}" y1="${y - r * 2.2}" x2="${x}" y2="${y - r * 1.25}" stroke="rgba(216,180,90,.75)" stroke-width="1.6"/><ellipse cx="${x}" cy="${y}" rx="${r}" ry="${r * 1.15}" fill="${c}"/><ellipse cx="${x}" cy="${y}" rx="${r * 1.9}" ry="${r * 2.1}" fill="url(#cgE)" opacity=".5"/><rect x="${x - r * .5}" y="${y - r * 1.38}" width="${r}" height="${r * .36}" rx="2" fill="#d8b45a"/><rect x="${x - r * .5}" y="${y + r * .95}" width="${r}" height="${r * .32}" rx="2" fill="#d8b45a"/><line x1="${x}" y1="${y + r * 1.28}" x2="${x}" y2="${y + r * 1.9}" stroke="#d8b45a" stroke-width="1.5"/><circle cx="${x}" cy="${y + r * 2.02}" r="${r * .18}" fill="#f6dd94"/></g>`;
function cgWrap(body, defs) {
  const S = `<svg viewBox="0 0 720 320" preserveAspectRatio="xMidYMid slice" xmlns="http://www.w3.org/2000/svg">
<defs><linearGradient id="cgF" x1="0" y1="0" x2="0" y2="1"><stop offset="55%" stop-color="rgba(6,7,13,0)"/><stop offset="100%" stop-color="rgba(6,7,13,.88)"/></linearGradient>${defs}</defs>
${body}
<rect width="720" height="320" fill="url(#cgF)"/></svg>`;
  return uniqIds(S, ['cgA','cgB','cgC','cgD','cgE','cgF']);
}
/* 定情 · 春巷桃花 */
function cgBgFirstlove() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<circle cx="560" cy="86" r="130" fill="url(#cgB)"/>
<g fill="rgba(176,120,132,.42)"><rect x="0" y="150" width="150" height="170"/><polygon points="0,150 160,150 80,116"/><rect x="220" y="160" width="130" height="160"/><polygon points="212,160 360,160 286,124"/><rect x="400" y="154" width="120" height="166"/><polygon points="392,154 528,154 460,120"/></g>
<g fill="rgba(122,74,92,.58)"><rect x="0" y="176" width="110" height="144"/><polygon points="-10,176 120,176 55,140"/><rect x="480" y="170" width="110" height="150"/><polygon points="470,170 600,170 535,136"/><rect x="612" y="178" width="108" height="142"/><polygon points="602,178 720,178 665,144"/></g>
<rect x="0" y="240" width="720" height="80" fill="rgba(240,214,206,.5)"/>
<rect x="0" y="248" width="720" height="6" fill="rgba(196,140,150,.55)"/>
<g class="cg-drift">
<path d="M-10,64 Q120,98 252,78" stroke="rgba(92,58,66,.8)" stroke-width="7" fill="none"/>
<path d="M42,72 q30,-26 64,-12 M98,84 q26,-20 56,-6" stroke="rgba(92,58,66,.65)" stroke-width="5" fill="none"/>
${[[62,78],[114,86],[170,92],[216,84],[90,66],[152,74]].map(p => `<g fill="#ffb3c6"><circle cx="${p[0]}" cy="${p[1]}" r="7"/><circle cx="${p[0] - 8}" cy="${p[1] + 3}" r="6"/><circle cx="${p[0] + 8}" cy="${p[1] + 3}" r="6"/><circle cx="${p[0] - 4}" cy="${p[1] + 8}" r="6"/><circle cx="${p[0] + 4}" cy="${p[1] + 8}" r="6"/><circle cx="${p[0]}" cy="${p[1] + 3}" r="4.5" fill="#ff8fab"/></g>`).join('')}
</g>
${cgPetal(320,150,7,'#ffc2d1',18)}${cgPetal(372,200,6,'#ffb3c6',-24)}${cgPetal(300,236,6,'#ffc9d6',40)}${cgPetal(422,170,5,'#ffd3de',-8)}${cgPetal(252,192,5,'#ffb3c6',60)}
<path d="M182,320 q6,-40 -4,-74 M182,248 q-20,-10 -30,-28 M182,254 q22,-8 30,-26" stroke="rgba(110,70,80,.6)" stroke-width="5" fill="none"/>
${cgDot(410,60,2.4,'#fff',.9)}${cgDot(462,112,1.8,'#fff',.7)}${cgDot(362,92,1.6,'#fff',.6)}
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#ffeef0"/><stop offset="55%" stop-color="#ffdfe4"/><stop offset="100%" stop-color="#f4cbd2"/></linearGradient>
<radialGradient id="cgB"><stop offset="0%" stop-color="rgba(255,244,238,.95)"/><stop offset="100%" stop-color="rgba(255,244,238,0)"/></radialGradient>`);
}
/* enc0 灯会惊鸿 */
function cgBgEnc0() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<circle cx="150" cy="60" r="56" fill="url(#cgB)"/><circle cx="150" cy="60" r="20" fill="#f2ecd8" opacity=".95"/>
<circle cx="150" cy="60" r="70" fill="none" stroke="rgba(242,236,216,.14)" stroke-width="1.5"/>
<path d="M-20,44 Q200,96 420,40" stroke="rgba(255,196,120,.4)" stroke-width="2" fill="none"/>
<path d="M240,20 Q460,74 740,26" stroke="rgba(255,196,120,.4)" stroke-width="2" fill="none"/>
<g class="cg-drift">${cgLantern(70,86,15,'#ff8f5a')}${cgLantern(162,94,12,'#ff6a7a')}${cgLantern(258,88,16,'#ffa25a')}${cgLantern(348,74,11,'#ff7a8a')}</g>
<g class="cg-drift2">${cgLantern(322,52,12,'#ff6a6a')}${cgLantern(422,64,15,'#ff9a5a')}${cgLantern(522,54,12,'#ff7a6a')}${cgLantern(622,60,14,'#ffa05a')}</g>
<g fill="rgba(10,8,24,.9)"><polygon points="-10,320 -10,250 120,250 140,232 260,232 276,250 330,250 330,320"/><polygon points="360,320 360,258 470,258 486,242 580,242 596,258 640,258 640,320"/></g>
<rect x="60" y="272" width="44" height="48" fill="rgba(255,190,110,.55)"/><rect x="180" y="272" width="40" height="48" fill="rgba(255,170,110,.4)"/><rect x="420" y="276" width="40" height="44" fill="rgba(255,190,110,.45)"/>
${cgDot(300,152,3,'#ffd98a',.8)}${cgDot(392,122,2.2,'#ff9aa8',.7)}${cgDot(482,162,2.6,'#ffd98a',.75)}${cgDot(562,122,2,'#ffca7a',.6)}${cgDot(242,182,2,'#ff9aa8',.5)}${cgDot(622,172,2.2,'#ffd98a',.55)}
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#150f3e"/><stop offset="60%" stop-color="#2a1858"/><stop offset="100%" stop-color="#45256e"/></linearGradient>
<radialGradient id="cgB"><stop offset="0%" stop-color="rgba(242,236,216,.55)"/><stop offset="100%" stop-color="rgba(242,236,216,0)"/></radialGradient>
<radialGradient id="cgE"><stop offset="0%" stop-color="rgba(255,196,110,.75)"/><stop offset="100%" stop-color="rgba(255,196,110,0)"/></radialGradient>`);
}
/* enc1 山道遇匪 */
function cgBgEnc1() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<circle cx="500" cy="198" r="80" fill="url(#cgB)"/><circle cx="500" cy="198" r="30" fill="#ffbf80" opacity=".92"/>
<polygon points="0,320 0,150 130,86 260,180 380,120 520,200 660,140 720,170 720,320" fill="rgba(58,26,46,.7)"/>
<polygon points="0,320 0,208 170,150 320,232 470,170 620,240 720,196 720,320" fill="rgba(38,16,32,.85)"/>
<path d="M0,320 L140,252 L240,286 L330,242 L470,296 L560,262 L720,310" stroke="rgba(255,190,130,.26)" stroke-width="5" fill="none"/>
<g class="cg-drift">
${cgDot(222,150,3,'#ffe6b8',.9)}${cgDot(252,128,2.2,'#fff',.8)}${cgDot(198,172,2.4,'#ffe6b8',.7)}
<g transform="translate(238,146) rotate(38)"><rect x="-1.6" y="-34" width="3.2" height="68" rx="1.6" fill="rgba(255,255,255,.65)"/></g>
<g transform="translate(206,170) rotate(-30)"><rect x="-1.4" y="-26" width="2.8" height="52" rx="1.4" fill="rgba(255,240,214,.5)"/></g>
</g>
<g stroke="rgba(16,8,18,.85)" stroke-width="2.4" fill="none"><path d="M60,320 q4,-22 -2,-38 M84,320 q6,-18 0,-34 M112,320 q-6,-20 2,-36"/><path d="M560,320 q8,-16 2,-30 M600,320 q-8,-14 0,-28"/></g>
<path d="M332,90 q26,-18 58,-8 q-30,2 -44,16 Z" fill="rgba(255,214,170,.3)"/>
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#3c1c3a"/><stop offset="55%" stop-color="#77363c"/><stop offset="100%" stop-color="#b06148"/></linearGradient>
<radialGradient id="cgB"><stop offset="0%" stop-color="rgba(255,190,120,.8)"/><stop offset="100%" stop-color="rgba(255,190,120,0)"/></radialGradient>`);
}
/* enc2 秘境邂逅 */
function cgBgEnc2() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<circle cx="540" cy="84" r="62" fill="url(#cgB)"/><circle cx="540" cy="84" r="22" fill="#ddf7ec" opacity=".95"/>
<circle cx="540" cy="84" r="44" fill="none" stroke="rgba(168,240,255,.3)" stroke-width="1.5"/>
<circle cx="540" cy="84" r="64" fill="none" stroke="rgba(168,240,255,.16)" stroke-width="1"/>
<g fill="rgba(8,38,46,.72)">
  <path d="M28,238 L66,152 L92,170 L124,128 L166,198 L146,238 Z"/>
  <path d="M268,218 L308,122 L340,148 L372,110 L418,182 L394,218 Z"/>
</g>
<line x1="344" y1="152" x2="354" y2="218" stroke="rgba(210,245,255,.35)" stroke-width="3"/>
<ellipse cx="180" cy="252" rx="240" ry="30" fill="rgba(214,242,250,.16)"/>
<ellipse cx="420" cy="284" rx="300" ry="36" fill="rgba(214,242,250,.2)"/>
<ellipse cx="600" cy="240" rx="200" ry="24" fill="rgba(214,242,250,.13)"/>
<g class="cg-drift">${cgDot(360,120,2.6,'#a8f0ff',.85)}${cgDot(432,162,2,'#a8f0ff',.6)}${cgDot(302,82,2,'#d8fff2',.7)}${cgDot(642,142,2.4,'#ffd98a',.6)}${cgDot(242,142,1.8,'#a8f0ff',.55)}</g>
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#0b2836"/><stop offset="60%" stop-color="#154a58"/><stop offset="100%" stop-color="#1d6166"/></linearGradient>
<radialGradient id="cgB"><stop offset="0%" stop-color="rgba(221,247,236,.6)"/><stop offset="100%" stop-color="rgba(221,247,236,0)"/></radialGradient>`);
}
/* enc3 夜市迷香 */
function cgBgEnc3() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<ellipse cx="360" cy="292" rx="380" ry="60" fill="rgba(190,120,220,.12)"/>
<path d="M-10,36 Q180,78 380,34" stroke="rgba(255,170,140,.4)" stroke-width="2" fill="none"/>
<g class="cg-drift">${cgLantern(60,72,14,'#ff5a6a')}${cgLantern(152,82,11,'#ff7a5a')}${cgLantern(242,74,13,'#ff5a72')}${cgLantern(332,62,10,'#ff8a5a')}</g>
<g class="cg-drift2">${cgLantern(502,46,11,'#ff5a6a')}${cgLantern(602,54,13,'#ff7a5a')}${cgLantern(692,44,10,'#ff5a72')}</g>
<g fill="rgba(14,6,22,.92)"><polygon points="-10,320 -10,238 150,238 150,226 170,226 170,238 260,238 276,222 320,238 320,320"/><rect x="40" y="252" width="70" height="30" rx="3" fill="rgba(255,180,120,.55)"/><rect x="140" y="252" width="54" height="30" rx="3" fill="rgba(255,150,140,.4)"/><polygon points="380,320 380,246 500,246 514,230 560,230 574,246 640,246 640,320"/><rect x="420" y="258" width="60" height="28" rx="3" fill="rgba(255,180,120,.5)"/></g>
<line x1="342" y1="30" x2="342" y2="180" stroke="rgba(14,6,22,.9)" stroke-width="3"/>
<rect x="318" y="180" width="48" height="26" rx="4" fill="rgba(200,60,80,.9)" stroke="rgba(246,221,148,.6)" stroke-width="1.5"/>
${cgDot(402,142,2.4,'#ff9aa8',.7)}${cgDot(462,172,2,'#ffd98a',.6)}${cgDot(282,152,2.2,'#c9a2ff',.55)}${cgDot(542,132,2,'#ff9aa8',.5)}
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#1c0d2c"/><stop offset="60%" stop-color="#331245"/><stop offset="100%" stop-color="#4a1a55"/></linearGradient>
<radialGradient id="cgE"><stop offset="0%" stop-color="rgba(255,150,120,.7)"/><stop offset="100%" stop-color="rgba(255,150,120,0)"/></radialGradient>`);
}
/* enc4 病榻之恩 · 药庐 */
function cgBgEnc4() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<g stroke="rgba(20,12,6,.5)" stroke-width="2"><line x1="0" y1="34" x2="720" y2="26"/><line x1="0" y1="96" x2="720" y2="88"/></g>
<g class="cg-drift">
${[70,150,235,322].map(x => `<g><line x1="${x}" y1="36" x2="${x}" y2="58" stroke="rgba(90,60,30,.9)" stroke-width="2"/><polygon points="${x - 13},58 ${x + 13},58 ${x},104" fill="rgba(120,88,44,.85)"/><line x1="${x}" y1="58" x2="${x}" y2="63" stroke="rgba(200,170,110,.8)" stroke-width="3"/><circle cx="${x}" cy="41" r="4" fill="none" stroke="rgba(200,170,110,.5)" stroke-width="1.5"/></g>`).join('')}
</g>
<rect x="96" y="122" width="150" height="102" rx="6" fill="rgba(207,228,255,.72)"/>
<circle cx="196" cy="148" r="10" fill="rgba(255,255,255,.8)"/>
<rect x="96" y="122" width="150" height="102" rx="6" fill="none" stroke="rgba(70,44,20,.95)" stroke-width="7"/>
<line x1="171" y1="122" x2="171" y2="224" stroke="rgba(70,44,20,.95)" stroke-width="6"/>
<line x1="96" y1="173" x2="246" y2="173" stroke="rgba(70,44,20,.95)" stroke-width="6"/>
<rect x="0" y="252" width="720" height="68" fill="rgba(24,14,8,.9)"/>
<g fill="rgba(60,38,18,.95)"><rect x="0" y="216" width="200" height="12" rx="3"/>${[20,70,120,165].map(x => `<rect x="${x}" y="188" width="24" height="28" rx="7"/><rect x="${x + 5}" y="180" width="14" height="8" rx="3"/>`).join('')}</g>
<ellipse cx="300" cy="238" rx="112" ry="14" fill="rgba(90,58,28,.8)"/>
<path d="M272,232 q10,-16 24,0 q12,14 26,0" stroke="rgba(255,255,255,.5)" stroke-width="3" fill="none" class="cg-drift"/>
<circle cx="368" cy="218" r="10" fill="rgba(255,214,150,.9)"/><circle cx="368" cy="218" r="32" fill="url(#cgE)" opacity=".65"/>
${cgDot(422,140,2,'#ffd9a0',.6)}${cgDot(472,182,1.6,'#ffd9a0',.5)}${cgDot(522,122,1.8,'#fff',.4)}
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#2a1c10"/><stop offset="60%" stop-color="#43301c"/><stop offset="100%" stop-color="#583a20"/></linearGradient>
<radialGradient id="cgE"><stop offset="0%" stop-color="rgba(255,206,130,.85)"/><stop offset="100%" stop-color="rgba(255,206,130,0)"/></radialGradient>`);
}
/* enc5 仙盟大典 */
function cgBgEnc5() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<circle cx="360" cy="92" r="112" fill="url(#cgB)"/>
<g fill="rgba(12,14,34,.95)"><rect x="30" y="0" width="34" height="320"/><rect x="656" y="0" width="34" height="320"/><rect x="150" y="0" width="26" height="320"/><rect x="544" y="0" width="26" height="320"/></g>
<g fill="rgba(216,180,90,.55)"><rect x="26" y="0" width="42" height="7"/><rect x="652" y="0" width="42" height="7"/><rect x="146" y="0" width="34" height="5"/><rect x="540" y="0" width="34" height="5"/></g>
<g class="cg-drift">
${[[220,46],[322,36],[432,44]].map(p => `<g><line x1="${p[0]}" y1="${p[1]}" x2="${p[0]}" y2="${p[1] + 88}" stroke="rgba(200,60,70,.85)" stroke-width="26"/><line x1="${p[0]}" y1="${p[1]}" x2="${p[0]}" y2="${p[1] + 88}" stroke="rgba(246,221,148,.25)" stroke-width="26" stroke-dasharray="2 10"/><circle cx="${p[0]}" cy="${p[1] + 104}" r="6" fill="#d8b45a"/></g>`).join('')}
</g>
<rect x="0" y="286" width="720" height="34" fill="rgba(10,10,26,.92)"/>
<ellipse cx="360" cy="290" rx="270" ry="16" fill="rgba(246,221,148,.16)"/>
${cgDot(302,122,2.6,'#ffe6a8',.85)}${cgDot(422,102,2.2,'#ffe6a8',.7)}${cgDot(262,172,1.8,'#ffd98a',.6)}${cgDot(472,162,2.4,'#fff2c8',.7)}${cgDot(522,92,1.8,'#ffe6a8',.55)}${cgDot(202,92,2,'#fff',.5)}
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#12183c"/><stop offset="60%" stop-color="#292a5c"/><stop offset="100%" stop-color="#433068"/></linearGradient>
<radialGradient id="cgB"><stop offset="0%" stop-color="rgba(255,228,160,.5)"/><stop offset="100%" stop-color="rgba(255,228,160,0)"/></radialGradient>`);
}
/* enc6 客栈夜雨 */
function cgBgEnc6() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<g class="cg-rain">${Array.from({ length: 26 }, (_, i) => `<line x1="${(i * 31) % 720}" y1="${(i * 53) % 300}" x2="${((i * 31) % 720) - 7}" y2="${((i * 53) % 300) + 22}" stroke="rgba(168,196,255,.3)" stroke-width="1.6"/>`).join('')}</g>
<rect x="52" y="58" width="240" height="168" rx="8" fill="#101c30"/>
<circle cx="130" cy="104" r="14" fill="#e8ecf4" opacity=".85"/>
${cgDot(202,146,1.6,'#cfe0ff',.5)}${cgDot(92,176,1.4,'#cfe0ff',.4)}
<rect x="52" y="58" width="240" height="168" rx="8" fill="none" stroke="rgba(90,64,28,.98)" stroke-width="9"/>
<line x1="172" y1="58" x2="172" y2="226" stroke="rgba(90,64,28,.98)" stroke-width="7"/>
<line x1="52" y1="142" x2="292" y2="142" stroke="rgba(90,64,28,.98)" stroke-width="7"/>
<rect x="48" y="50" width="248" height="9" fill="rgba(90,64,28,.98)"/>
<path d="M322,42 l-14,40 12,4 -18,52" stroke="rgba(220,232,255,.22)" stroke-width="3" fill="none"/>
<g fill="rgba(16,10,6,.95)"><rect x="0" y="262" width="330" height="16" rx="6"/><rect x="30" y="278" width="16" height="42"/><rect x="250" y="278" width="16" height="42"/></g>
<ellipse cx="120" cy="258" rx="26" ry="7" fill="rgba(235,240,248,.85)"/>
<path d="M104,244 q16,-14 32,0" stroke="rgba(235,240,248,.55)" stroke-width="3" fill="none"/>
<circle cx="404" cy="242" r="12" fill="rgba(255,206,130,.9)"/><circle cx="404" cy="242" r="46" fill="url(#cgE)" opacity=".55"/>
${cgDot(482,122,1.8,'#cfe0ff',.5)}${cgDot(562,162,1.5,'#cfe0ff',.4)}
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#0c1424"/><stop offset="60%" stop-color="#1a2c48"/><stop offset="100%" stop-color="#23405e"/></linearGradient>
<radialGradient id="cgE"><stop offset="0%" stop-color="rgba(255,206,130,.8)"/><stop offset="100%" stop-color="rgba(255,206,130,0)"/></radialGradient>`);
}
/* 大婚 · 永结同心 */
function cgBgPropose() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<circle cx="360" cy="122" r="122" fill="url(#cgB)"/>
<path d="M0,26 Q90,54 180,26 Q270,54 360,26 Q450,54 540,26 Q630,54 720,26 L720,0 L0,0 Z" fill="rgba(150,24,42,.92)"/>
<path d="M0,26 Q90,54 180,26 Q270,54 360,26 Q450,54 540,26 Q630,54 720,26" stroke="rgba(246,221,148,.7)" stroke-width="2.5" fill="none"/>
<circle cx="140" cy="66" r="4" fill="#d8b45a"/><circle cx="360" cy="58" r="4" fill="#d8b45a"/><circle cx="580" cy="66" r="4" fill="#d8b45a"/>
<g class="cg-drift">${cgLantern(70,98,15,'#e2304a')}${cgLantern(650,98,15,'#e2304a')}</g>
<text x="252" y="198" font-size="58" font-family="STKaiti,KaiTi,serif" fill="rgba(246,221,148,.95)" text-anchor="middle">囍</text>
<circle cx="252" cy="178" r="52" fill="none" stroke="rgba(246,221,148,.35)" stroke-width="1.5"/>
<g class="cg-flicker">
<rect x="152" y="212" width="14" height="44" rx="4" fill="#f2e2c0"/><line x1="159" y1="212" x2="159" y2="204" stroke="#8a5a2a" stroke-width="3"/>
<ellipse cx="159" cy="196" rx="6" ry="11" fill="#ffcf6a"/><ellipse cx="159" cy="199" rx="2.6" ry="5.5" fill="#fff3c8"/>
<rect x="118" y="256" width="84" height="8" rx="3" fill="rgba(120,40,30,.9)"/>
</g>
<g class="cg-flicker2">
<rect x="348" y="212" width="14" height="44" rx="4" fill="#f2e2c0"/><line x1="355" y1="212" x2="355" y2="204" stroke="#8a5a2a" stroke-width="3"/>
<ellipse cx="355" cy="196" rx="6" ry="11" fill="#ffcf6a"/><ellipse cx="355" cy="199" rx="2.6" ry="5.5" fill="#fff3c8"/>
<rect x="314" y="256" width="84" height="8" rx="3" fill="rgba(120,40,30,.9)"/>
</g>
<path d="M422,60 q60,30 30,80 q-24,44 30,70 q60,-10 80,-60" stroke="rgba(255,140,150,.4)" stroke-width="3" fill="none" class="cg-drift2"/>
<g class="cg-fall">${cgPetal(432,92,7,'#ff8fa0',20)}${cgPetal(482,152,6,'#e2506a',-30)}${cgPetal(532,112,5,'#ff8fa0',50)}${cgPetal(582,182,6,'#ffae98',-12)}${cgPetal(622,132,5,'#e2506a',36)}</g>
<rect x="0" y="284" width="720" height="36" fill="rgba(40,6,14,.9)"/>
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#380d1a"/><stop offset="60%" stop-color="#691c2c"/><stop offset="100%" stop-color="#8a2836"/></linearGradient>
<radialGradient id="cgB"><stop offset="0%" stop-color="rgba(255,190,140,.4)"/><stop offset="100%" stop-color="rgba(255,190,140,0)"/></radialGradient>
<radialGradient id="cgE"><stop offset="0%" stop-color="rgba(255,170,110,.8)"/><stop offset="100%" stop-color="rgba(255,170,110,0)"/></radialGradient>`);
}
/* 添丁之喜 */
function cgBgBirth() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<rect x="60" y="66" width="170" height="122" rx="6" fill="rgba(255,232,190,.9)"/>
<rect x="60" y="66" width="170" height="122" rx="6" fill="none" stroke="rgba(80,52,26,.95)" stroke-width="8"/>
<line x1="145" y1="66" x2="145" y2="188" stroke="rgba(80,52,26,.95)" stroke-width="6"/>
<line x1="60" y1="127" x2="230" y2="127" stroke="rgba(80,52,26,.95)" stroke-width="6"/>
<polygon points="62,68 228,68 322,242 242,256" fill="rgba(255,226,168,.2)"/>
<polygon points="72,68 162,68 262,242 212,252" fill="rgba(255,232,190,.12)"/>
<g fill="rgba(50,32,16,.92)"><rect x="268" y="196" width="120" height="12" rx="4"/><rect x="276" y="208" width="10" height="66"/><rect x="370" y="208" width="10" height="66"/><rect x="286" y="176" width="84" height="22" rx="10"/></g>
<path d="M292,182 q40,18 72,0" stroke="rgba(240,196,150,.55)" stroke-width="7" fill="none"/>
<line x1="328" y1="128" x2="328" y2="176" stroke="rgba(90,60,30,.9)" stroke-width="2.5"/>
<circle cx="328" cy="120" r="7" fill="rgba(226,106,111,.85)"/>
<circle cx="328" cy="106" r="4" fill="rgba(246,221,148,.8)"/><circle cx="318" cy="114" r="3" fill="rgba(159,215,255,.8)"/><circle cx="338" cy="114" r="3" fill="rgba(159,215,255,.8)"/>
<g fill="rgba(60,38,18,.9)"><rect x="30" y="238" width="14" height="52"/><ellipse cx="37" cy="232" rx="20" ry="9"/><path d="M20,226 q17,-34 34,0" stroke="rgba(60,38,18,.9)" stroke-width="4" fill="none"/></g>
${cgPetal(62,222,5,'#ffb3c6',24,.9)}${cgPetal(52,206,4,'#ffc9d6',-20,.85)}${cgPetal(76,210,4,'#ffb3c6',60,.8)}
<g class="cg-drift">${cgDot(422,102,2.2,'#ffe6b8',.7)}${cgDot(482,152,1.8,'#ffe6b8',.55)}${cgDot(542,92,1.6,'#fff',.5)}${cgDot(602,142,1.8,'#ffe6b8',.45)}</g>
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#302216"/><stop offset="60%" stop-color="#4e372a"/><stop offset="100%" stop-color="#654634"/></linearGradient>`);
}
/* 双修共渡 */
function cgBgShuangxiu() {
  return cgWrap(`
<rect width="720" height="320" fill="url(#cgA)"/>
<circle cx="320" cy="190" r="132" fill="url(#cgB)"/>
<g fill="none" stroke="rgba(127,224,255,.18)"><circle cx="320" cy="200" r="70"/><circle cx="320" cy="200" r="96" stroke-dasharray="4 8"/><circle cx="320" cy="200" r="122" stroke="rgba(201,162,255,.14)"/></g>
<g class="cg-pulse">
<circle cx="320" cy="196" r="42" fill="rgba(127,224,255,.35)"/>
<path d="M320,154 A42,42 0 0 1 320,238 A21,21 0 0 1 320,196 A21,21 0 0 0 320,154 Z" fill="rgba(201,162,255,.5)"/>
<circle cx="320" cy="175" r="7" fill="rgba(201,162,255,.8)"/><circle cx="320" cy="217" r="7" fill="rgba(127,224,255,.8)"/>
</g>
<g fill="rgba(6,10,20,.92)"><circle cx="216" cy="184" r="15"/><path d="M192,250 Q192,202 216,202 Q240,202 240,250 Z"/><circle cx="424" cy="184" r="15"/><path d="M400,250 Q400,202 424,202 Q448,202 448,250 Z"/></g>
<path d="M244,194 Q320,158 396,194" stroke="rgba(168,240,255,.55)" stroke-width="3" fill="none" class="cg-drift"/>
<path d="M244,204 Q320,172 396,204" stroke="rgba(201,162,255,.4)" stroke-width="2.5" fill="none" class="cg-drift2"/>
${cgDot(182,122,2.2,'#a8f0ff',.7)}${cgDot(462,102,2,'#c9a2ff',.6)}${cgDot(522,152,1.8,'#a8f0ff',.5)}${cgDot(142,162,1.8,'#c9a2ff',.5)}${cgDot(562,92,1.5,'#fff',.45)}
`, `<linearGradient id="cgA" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="#0a1626"/><stop offset="60%" stop-color="#132e46"/><stop offset="100%" stop-color="#1a4054"/></linearGradient>
<radialGradient id="cgB"><stop offset="0%" stop-color="rgba(127,224,255,.3)"/><stop offset="55%" stop-color="rgba(201,162,255,.16)"/><stop offset="100%" stop-color="rgba(201,162,255,0)"/></radialGradient>`);
}
const CG_LIB = {
  firstlove: { title: '巷口桃花', quote: '巷口的桃花，今年也开了。', bg: cgBgFirstlove },
  m_firstlove: { title: '巷口桃花', quote: '巷口的桃花，今年也开了。', bg: cgBgFirstlove },
  enc0: { title: '灯会惊鸿', quote: '后会有期。', bg: cgBgEnc0 },
  enc1: { title: '乱世相逢', quote: '可还站得稳？', bg: cgBgEnc1 },
  enc2: { title: '云海初见', quote: '你也是为那桩机缘来的？', bg: cgBgEnc2 },
  enc3: { title: '夜市灯影', quote: '这坛酒，记你账上。', bg: cgBgEnc3 },
  enc4: { title: '药香情缘', quote: '药还热着，趁早喝了。', bg: cgBgEnc4 },
  enc5: { title: '大典惊鸿', quote: '此子……有点意思。', bg: cgBgEnc5 },
  enc6: { title: '夜雨同舟', quote: '别开灯，就这样坐会儿。', bg: cgBgEnc6 },
  propose: { title: '永结同心', quote: '可愿结为道侣，同修共渡？', bg: cgBgPropose },
  birth: { title: '添丁之喜', quote: '像你，也像我。', bg: cgBgBirth },
  shuangxiu: { title: '双修共渡', quote: '气随意转，周天共渡。', bg: cgBgShuangxiu },
};
/* 立绘白底抠图（canvas 泛洪去底 + 两圈羽化；跨域/失败返回 null 走光晕兜底） */
const CG_CUT = new Map();
function cgFloodClear(d, w, h) {
  const N = w * h, seen = new Uint8Array(N), q = [];
  const near = (i, t) => { const p = i * 4; return d[p] >= t && d[p + 1] >= t && d[p + 2] >= t; };
  for (let x = 0; x < w; x++) q.push(x, N - w + x);
  for (let y = 0; y < h; y++) q.push(y * w, y * w + w - 1);
  const ring1 = [];
  while (q.length) {
    const i = q.pop();
    if (seen[i]) continue;
    seen[i] = 1;
    if (!near(i, 246)) continue;
    d[i * 4 + 3] = 0;
    ring1.push(i);
    const x = i % w, y = (i / w) | 0;
    if (x > 0) q.push(i - 1);
    if (x < w - 1) q.push(i + 1);
    if (y > 0) q.push(i - w);
    if (y < h - 1) q.push(i + w);
  }
  const ring2 = [];
  const nb = i => {
    const x = i % w, y = (i / w) | 0, r = [];
    if (x > 0) r.push(i - 1);
    if (x < w - 1) r.push(i + 1);
    if (y > 0) r.push(i - w);
    if (y < h - 1) r.push(i + w);
    return r;
  };
  for (const i of ring1) for (const j of nb(i)) {
    if (d[j * 4 + 3] > 0 && near(j, 224)) { d[j * 4 + 3] = Math.min(d[j * 4 + 3], 110); ring2.push(j); }
  }
  for (const i of ring2) for (const j of nb(i)) {
    if (d[j * 4 + 3] > 0 && near(j, 238)) d[j * 4 + 3] = Math.min(d[j * 4 + 3], 205);
  }
  return ring1.length;
}
function cutoutPortrait(src) {
  if (!CG_CUT.has(src)) {
    CG_CUT.set(src, new Promise(res => {
      const im = new Image();
      im.onload = () => {
        try {
          const cv = document.createElement('canvas');
          cv.width = im.naturalWidth; cv.height = im.naturalHeight;
          const cx = cv.getContext('2d');
          cx.drawImage(im, 0, 0);
          const id = cx.getImageData(0, 0, cv.width, cv.height);
          cgFloodClear(id.data, cv.width, cv.height);
          cx.putImageData(id, 0, 0);
          /* 边缘环带仍大量不透明 → 存在硬矩形边（暖金棚拍底 / 画框立绘），套椭圆软边蒙版 */
          const bw = cv.width, bh = cv.height;
          let keep = 0, tot = 0;
          for (let x = 0; x < bw; x += 3) for (const y of [0, 1, 2, bh - 3, bh - 2, bh - 1]) { tot++; if (id.data[(y * bw + x) * 4 + 3] > 40) keep++; }
          for (let y = 0; y < bh; y += 3) for (const x of [0, 1, 2, bw - 3, bw - 2, bw - 1]) { tot++; if (id.data[(y * bw + x) * 4 + 3] > 40) keep++; }
          if (keep / tot > 0.25) {
            cx.globalCompositeOperation = 'destination-in';
            const g = cx.createRadialGradient(bw / 2, bh * .4, bw * .26, bw / 2, bh * .4, bw * .62);
            g.addColorStop(0, 'rgba(0,0,0,1)');
            g.addColorStop(1, 'rgba(0,0,0,0)');
            cx.fillStyle = g;
            cx.fillRect(0, 0, bw, bh);
            cx.globalCompositeOperation = 'source-over';
          }
          res(cv);
        } catch (e) { res(null); }
      };
      im.onerror = () => res(null);
      im.src = src;
    }));
  }
  return CG_CUT.get(src);
}
/* 若美术提供了成 CG（assets/cg-<场景>[-<编号>].png / .mp4 / .webm），优先整图/整片替换 */
const CG_PROBE = new Map();
function probeCG(src) {
  if (!CG_PROBE.has(src)) {
    CG_PROBE.set(src, fetch(src, { method: 'HEAD' }).then(r => r.ok ? src : null).catch(() => null));
  }
  return CG_PROBE.get(src);
}
/* 该事件 CG 的出镜女角 */
function cgGirlFor(ev) {
  if (s.gender === 'm') {
    const encIdx = ev.enc != null ? ev.enc : (ev.id === 'm_firstlove' || ev.id === 'firstlove' ? 0 : null);
    if (encIdx != null) { const w = encWho(encIdx); return { aura: w.aura, pic: w.pic, name: w.name }; }
    if (s.lover) return { aura: s.lover.aura || '#f0a0c8', pic: s.lover.pic != null ? s.lover.pic : 0, name: s.lover.name };
    return null;
  }
  const variant = s.realm >= 5 ? 2 : (s.realm >= 3 ? 1 : 0);
  return { aura: REALM_COLOR[s.realm] || '#d8b45a', pic: variant, name: s.name };
}
function renderCG(mount, key, girl) {
  const c = CG_LIB[key];
  const aura = girl.aura || '#f0a0c8';
  const picKey = girl.pic == null ? 'm' : girl.pic;
  const src = girl.pic == null ? PORTRAIT_SRC.m : (PORTRAIT_SRC.f[girl.pic] || PORTRAIT_SRC.f[0]);
  mount.innerHTML = `<div class="cg" style="--aura:${aura}">
    <div class="cg-bg">${c.bg()}</div>
    <div class="cg-halo"></div>
    <div class="cg-shadow"></div>
    <div class="cg-girl"><div class="cg-body"></div></div>
    <div class="cg-sheen"></div>
    <div class="cg-tint"></div>
    <div class="cg-sub serif">${c.quote || ''}</div>
    <div class="cg-cap"><span class="serif">${c.title}</span>${girl.name ? `<em>${girl.name}</em>` : ''}<i>CG·动画</i></div>
  </div>`;
  const root = mount.querySelector('.cg');
  const slot = mount.querySelector('.cg-body');
  /* 鼠标视差：背景与人物反向轻移（替换旧监听，防止重复绑定） */
  if (mount.cgOff) mount.cgOff();
  const onMove = e => {
    const bg = root.querySelector('.cg-bg'), g = root.querySelector('.cg-girl');
    if (!bg || !g || !root.isConnected) return;
    const r = mount.getBoundingClientRect();
    const x = (e.clientX - r.left) / r.width - .5, y = (e.clientY - r.top) / r.height - .5;
    bg.style.transform = `translate(${x * -10}px, ${y * -7}px)`;
    g.style.transform = `translate(${x * -8}px, ${y * -5}px)`;
  };
  const onOut = () => {
    const bg = root.querySelector('.cg-bg'), g = root.querySelector('.cg-girl');
    if (bg) bg.style.transform = '';
    if (g) g.style.transform = '';
  };
  mount.addEventListener('mousemove', onMove);
  mount.addEventListener('mouseleave', onOut);
  mount.cgOff = () => { mount.removeEventListener('mousemove', onMove); mount.removeEventListener('mouseleave', onOut); };
  /* 资源覆盖链：指定女主视频 → 通用视频 → 指定女主图 → 通用图 → 内置动画场景 */
  const composeGirl = () => cutoutPortrait(src).then(cv => {
    if (!root.isConnected || !slot) return;
    if (cv) slot.appendChild(cv);
    else {
      const im = document.createElement('img');
      im.src = src; im.className = 'cg-masked'; im.alt = '';
      slot.appendChild(im);
    }
  });
  Promise.all([
    probeCG(`assets/cg-${key}-${picKey}.mp4`), probeCG(`assets/cg-${key}-${picKey}.webm`),
    probeCG(`assets/cg-${key}-${picKey}.png`),
    probeCG(`assets/cg-${key}.mp4`), probeCG(`assets/cg-${key}.webm`), probeCG(`assets/cg-${key}.png`),
  ]).then(f => {
    const media = f[0] || f[1] || f[2] || f[3] || f[4] || f[5];
    if (!root.isConnected) return;
    if (media) {
      root.classList.add('has-full');
      const inner = /\.(mp4|webm)$/.test(media)
        ? `<video class="cg-full" src="${media}" autoplay muted loop playsinline></video>`
        : `<img class="cg-full" src="${media}" alt="">`;
      root.insertAdjacentHTML('afterbegin', inner);
      const el = root.querySelector('.cg-full');
      const bail = () => { el.remove(); root.classList.remove('has-full'); composeGirl(); };
      if (el.tagName === 'VIDEO') { const p = el.play(); if (p && p.catch) p.catch(() => {}); }
      el.addEventListener('error', bail, { once: true });
      return;
    }
    composeGirl();
  });
}
/* 调试预览：__cg('enc0') / __cg('propose', 3) 指定女主编号 / __cg('propose', 1, true) 看女角玩家视角 */
window.__cg = function (key, pic, female) {
  s = newState({ name: female ? '演示女修' : '演示', gender: female ? 'f' : 'm', origin: 'tong', talent: 'tiruo' });
  if (female && typeof pic === 'number') s.realm = pic;
  $('scr-start').classList.add('hidden');
  $('scr-game').classList.remove('hidden');
  const m = /^enc(\d)$/.exec(key);
  if (m && s.gender === 'm') {
    const i = +m[1];
    s.flags['who' + i] = { ...HEROINES[i % HEROINES.length], name: '演示·' + HEROINES[i % HEROINES.length].desc };
    setMet(i);
  }
  if (key === 'firstlove' && s.gender === 'm') {
    s.flags.who0 = { ...HEROINES[0], name: '演示·青梅' };
    setMet(0);
  }
  if (key === 'propose' || key === 'shuangxiu' || key === 'birth') {
    const h = HEROINES[(typeof pic === 'number' && !female ? pic : 1) % HEROINES.length];
    s.lover = { ...h, name: '演示道侣', fav: 90, married: key !== 'propose' };
  }
  const ev = EVENTS.find(e => e.id === key) || { id: key, cat: 'romance', icon: '💮', title: (CG_LIB[key] || {}).title || key, text: 'CG 预览 · ' + key };
  renderPanel();
  presentEvent(ev);
  return 'CG · ' + key;
};

/* ---------------- 状态 ---------------- */
let s = null;
let phase = 'start';
let current = null;
let visibleChoices = [];
let autoPlaying = false;
const SAVE_KEY = 'xiantu-life-save-v1';

function newState(cfg) {
  const st = {
    name: cfg.name, gender: cfg.gender, origin: cfg.origin, talent: cfg.talent,
    root: rollRoot(cfg.origin), rootKnown: false,
    look: cfg.look != null ? cfg.look : ri(0, MALE_LOOKS.length - 1),
    age: 0, turn: 0, dead: false, cause: '', won: false,
    hp: 100, mood: 70, money: ORIGINS[cfg.origin].money,
    intl: 40 + (cfg.alloc ? cfg.alloc.intl : 0), cha: 40 + (cfg.alloc ? cfg.alloc.cha : 0),
    sta: 80 + (cfg.alloc ? cfg.alloc.sta : 0), gift: 10 + (cfg.alloc ? cfg.alloc.gift : 0),
    cult: 0, realm: 0, karma: 0,
    job: null,
    parents: {
      fa: { alive: true, age: ri(24, 34), fav: ri(60, 85) },
      mo: { alive: true, age: ri(22, 32), fav: ri(65, 90) },
    },
    friends: [],
    lover: null,
    children: [],
    milestones: [],
    flags: {},
  };
  const t = TALENTS[st.talent], o = ORIGINS[st.origin];
  if (t.mods) for (const k in t.mods) st[k] += t.mods[k];
  if (o.mods) for (const k in o.mods) st[k] += o.mods[k];
  if (st.talent === 'tiruo') st.hp = clamp(st.hp - 15, 1, 100);
  st.parents.fa.age += ri(0, 6); st.parents.mo.age += ri(0, 6);
  mark.call({ _s: st }, `降生于${o.name}`);
  mark.call({ _s: st }, `天赋·${t.name}`);
  const al = cfg.alloc;
  if (al && (al.sta || al.intl || al.cha || al.gift)) mark.call({ _s: st }, `初禀·体+${al.sta} 智+${al.intl} 魅+${al.cha} 赋+${al.gift}`);
  return st;
}
function mark(txt) {
  const st = this && this._s ? this._s : s;
  if (txt) st.milestones.push(`${st.age}岁 · ${txt}`);
}
function rollRoot(origin) {
  const bonus = origin === 'shijia' ? 2 : origin === 'tong' ? 1 : 0;
  const pool = [];
  for (const k in ROOTS) {
    let w = ROOTS[k].w * (k === 'tian' || k === 'zhen' ? (1 + bonus * 0.6) : 1);
    pool.push({ k, w });
  }
  return weightedPick(pool, x => x.w).k;
}
const curSpan = () => REALMS[s.realm].life + (s.flags.lifeBonus || 0);
const nextRealm = () => REALMS[s.realm + 1] || null;

/* ---------------- 数值 / 日志 ---------------- */
function applyFx(fx) {
  if (!fx) return [];
  const chips = [];
  for (const k of Object.keys(FX_LABEL)) {
    if (fx[k] === undefined || !fx[k]) continue;
    let v = fx[k];
    if (k === 'money' || k === 'cult') s[k] += v;
    else s[k] = clamp(s[k] + v, 0, 100);
    if (k === 'karma') s.karma = clamp(s.karma, -100, 100);
    chips.push({ k, v });
  }
  return chips;
}
function renderChips(chips, mount) {
  mount.innerHTML = chips.map(c =>
    `<span class="chip ${c.v > 0 ? 'up' : 'dn'}">${FX_LABEL[c.k]} ${c.v > 0 ? '+' : ''}${fmt(c.v)}</span>`).join('');
}
const LOG_MAX = 420;
function trimLog() {
  const box = $('log');
  while (box.children.length > LOG_MAX) box.removeChild(box.firstChild);
}
function log(html, cls = '') {
  const d = document.createElement('div');
  d.className = 'li ' + cls;
  d.innerHTML = html;
  $('log').appendChild(d);
  trimLog();
  $('log').scrollTop = $('log').scrollHeight;
}
function logChips(chips) {
  if (!chips.length) return;
  const d = document.createElement('div');
  d.className = 'chips';
  d.innerHTML = chips.map(c =>
    `<span class="chip ${c.v > 0 ? 'up' : 'dn'}">${FX_LABEL[c.k]} ${c.v > 0 ? '+' : ''}${fmt(c.v)}</span>`).join('');
  $('log').appendChild(d);
  $('log').scrollTop = $('log').scrollHeight;
}
function logYear() {
  const d = document.createElement('div');
  d.className = 'y-head';
  d.innerHTML = `<span class="age serif">${s.age} 岁</span><span>第 ${s.turn} 年</span>`;
  $('log').appendChild(d);
  trimLog();
  $('log').scrollTop = $('log').scrollHeight;
}
function showBanner(kind, title, sub) {
  const b = $('banner');
  b.className = kind;
  b.innerHTML = `<div class="bn"><div class="t serif">${title}</div><div class="s">${sub || ''}</div></div>`;
  setTimeout(() => b.classList.add('fade'), 1900);
  setTimeout(() => { b.className = 'hidden'; }, 2800);
}

/* ---------------- 事件库 ---------------- */
const CAT_NAME = { family:'家常', school:'求学', sect:'宗门', romance:'情缘', wedding:'喜缘', battle:'争斗', treasure:'机缘', misfortune:'祸事', death:'生死', western:'异域', cultivate:'修行', festival:'人间' };

const EVENTS = [
  /* ===== 幼年 ===== */
  { id:'cold', age:[1,70], w:9, cat:'misfortune', icon:'🤒', title:'风寒入体',
    cond:() => R() < (s.talent === 'tiruo' ? 0.9 : 0.3),
    text:() => s.age < 7 ? '一场风寒来得凶猛，你烧得迷迷糊糊，全家人彻夜守在床前。' : '时疫入体，你病倒了，汤药一碗接一碗地灌。',
    fx:{ hp:-15, mood:-10 } },
  { id:'coins', age:[2,12], w:6, cat:'treasure', icon:'🪙', title:'拾获铜钱',
    text:() => '路边石缝里闪着微光——几枚铜钱！你左右看看，悄悄揣进了怀里。',
    fx:{ money:20, mood:5 } },
  { id:'praise', age:[3,12], w:6, cat:'family', icon:'😊', title:'邻里夸赞',
    text:() => '你伶俐乖巧招人疼，邻里见了都要夸一句：“这孩子，将来必成大器。”',
    fx:{ mood:6, cha:2 }, wmul:() => s.talent === 'lingxi' ? 2 : 1 },
  { id:'fall', age:[2,10], w:5, cat:'misfortune', icon:'🤕', title:'顽皮摔伤',
    text:() => '爬树掏鸟窝时脚下一滑，摔得鼻青脸肿，娘心疼得直掉泪。',
    fx:{ hp:-10, sta:-5 } },
  { id:'immortal_meet', age:[4,10], w:2, cat:'sect', icon:'🧙', title:'路遇仙翁',
    text:() => '村口来了位白须仙翁，他摸摸你的头，只道“骨骼清奇，可惜了”，飘然而去。你却记住了那句话，日夜琢磨。',
    fx:{ intl:5, mood:8 } },
  { id:'sibling', age:[3,14], w:4, cat:'family', icon:'🍼', title:'家中添丁',
    text:() => '娘亲又添了一个小家伙，家里热闹了，也更拮据了。',
    fx:{ mood:4, money:-100 } },
  { id:'cat', age:[2,12], w:4, cat:'family', icon:'🐱', title:'灵猫作伴',
    text:() => '一只通体雪白的小猫赖在你家不走了，你给它取名“团子”，从此多了个玩伴。',
    fx:{ mood:5 } },

  /* ===== 少年 ===== */
  { id:'exam_win', age:[8,18], w:6, cat:'school', icon:'📝', title:'书院夺魁',
    text:() => '书院岁考放榜，你高居榜首，先生捋须而笑，同窗啧啧称羡。',
    fx:{ intl:4, mood:8 }, cond:() => s.intl >= 45 },
  { id:'bully', age:[8,18], w:5, cat:'school', icon:'😤', title:'同窗倾轧',
    text:() => '几个世家子弟合伙排挤你，冷言冷语像针一样扎人。',
    fx:() => s.cha >= 60 ? { mood:-3, cha:1 } : { mood:-8 } },
  { id:'hunt', age:[10,18], w:4, cat:'misfortune', icon:'🏹', title:'狩猎受伤',
    text:() => '随猎队进山，一头受惊的野猪直冲过来，你躲闪不及被掀翻在地。',
    fx:{ hp:-12 } },
  { id:'scroll', age:[8,18], w:3, cat:'treasure', icon:'📜', title:'残页奇缘',
    text:() => '旧书摊的故纸堆里，你翻出半页残缺功法。依着残页吐纳，竟真有一丝暖流游走四肢百骸。',
    fx:{ intl:6, cult:8 } },
  { id:'flood', age:[7,20], w:3, cat:'misfortune', icon:'🌊', title:'山洪暴发',
    text:() => '连日暴雨，山洪冲毁了半个村子。你家舍财物受损，所幸人皆平安。',
    fx:{ hp:-10, money:-150, mood:-8 } },
  { id:'friend', age:[7,40], w:6, cat:'romance', icon:'🤝', title:'结识挚友',
    text:() => '你与一位意气相投的同龄人一见如故，结为挚友，约定“苟富贵，勿相忘”。',
    side:() => { if (s.friends.length < 9) s.friends.push(randName()); },
    fx:{ mood:8 }, wmul:() => s.talent === 'lingxi' ? 2 : 1 },
  { id:'sword_tomb', age:[10,20], w:2, cat:'treasure', icon:'🗡️', title:'剑冢拾遗',
    text:() => '后山剑冢，断剑如林。你鬼使神差握住一柄锈剑，锈皮剥落处寒光乍现，似有剑灵轻鸣。',
    fx:{ cult:15, sta:3, mood:5 } },
  { id:'owl', age:[10,18], w:1, cat:'western', icon:'🦉', title:'异域来信',
    text:() => '一只灰羽巨雕穿过云层，投下一封火漆信函——万里之外的“魔法院”邀你入学修习异界法术。你研究了半宿，将其中的符文原理抄进了笔记。',
    fx:{ intl:8, mood:6 } },

  /* ===== 青年 ===== */
  { id:'market', age:[16,60], w:6, cat:'treasure', icon:'🏪', title:'坊市淘宝',
    roll:() => R() < (s.origin !== 'pin' ? 0.62 : 0.45)
      ? { out:'地摊上蒙尘的铜镜竟是法器！掌柜看走了眼，你低价购入，转手便是十倍利。', fx:{ money:400, mood:8 } }
      : { out:'逛了一整天，只买了个号称“辟邪”的玉佩，回来越看越像萝卜。', fx:{ money:-80 } } },
  { id:'scam', age:[16,70], w:4, cat:'misfortune', icon:'🕴️', title:'奸商设局',
    text:() => '一位“落魄散修”哭诉要卖祖传丹方，你心一软买了，回去一试——丹炉炸了。',
    fx:{ money:-250, mood:-8, hp:-5 } },
  { id:'beast', age:[16,65], w:5, cat:'battle', icon:'🐗', title:'猎妖得宝',
    roll:() => {
      const win = R() < 0.55 + s.sta * 0.003 + s.realm * 0.05 + (s.talent === 'jianxin' ? TALENTS.jianxin.fightBonus : 0);
      return win
        ? { out:'你随队猎杀一头铁背妖猪，分得一枚妖丹。炼化入体，气血翻涌。', fx:{ money:200, cult:15, hp:-8 } }
        : { out:'妖猪狂性大发，你被獠牙划伤了肩膀，只分到几两肉钱。', fx:{ hp:-18, money:60 } };
    } },
  { id:'plague', age:[10,70], w:3, cat:'misfortune', icon:'🦠', title:'疫病流行',
    text:() => '疫病席卷坊市，家家闭户。你也中招躺了半月，靠一副好底子硬扛了过来。',
    fx:{ hp:-20, mood:-10, money:-100 }, wmul:() => s.talent === 'tiruo' ? 2 : 1 },
  { id:'drunk', age:[16,60], w:4, cat:'festival', icon:'🍶', title:'醉后失态',
    text:() => '席间推杯换盏，你喝得酩酊大醉，当众吟了首歪诗，第二天没脸见人。',
    fx:{ mood:5, cha:-2, money:-80 } },
  { id:'sect_task', age:[18,80], w:5, cat:'sect', icon:'⛰️', title:'宗门任务',
    cond:() => s.job && s.job.includes('弟子'),
    text:() => '你接下宗门任务，孤身入云梦泽采七叶灵芝。三日后出泽，篓中灵芝还沾着妖兽的涎水。',
    fx:{ cult:20, money:150, hp:-8, mood:4 } },
  { id:'elder_pass', age:[18,80], w:2, cat:'treasure', icon:'🧝', title:'前辈传功',
    text:() => '山亭避雨，一位重伤老修士拉住你，将毕生感悟倾囊相授，言毕溘然长逝。你朝遗蜕磕了三个响头。',
    fx:{ cult:35, intl:5, karma:5 } },
  { id:'spring', age:[14,70], w:2, cat:'treasure', icon:'⛲', title:'灵泉洗髓',
    text:() => '深涧寒潭之下暗涌灵泉。你咬咬牙潜了下去——出水那一刻，浑身浊垢剥离，说不出的轻快。',
    fx:{ hp:20, sta:10, mood:8 } },
  { id:'pouch', age:[16,80], w:2, cat:'treasure', icon:'💰', title:'无主储物袋',
    text:() => '乱石岗上躺着一只带血的储物袋，主人怕是凶多吉少。你攥着袋口犹豫了片刻……还是收下了。',
    fx:{ money:500, karma:-4, mood:3 } },
  { id:'libai', age:[16,80], w:1, cat:'festival', icon:'🌕', title:'醉仙楼遇剑仙',
    text:() => '醉仙楼上，一位青莲居士打扮的狂客邀你共饮，拔剑起舞，剑光如银河落九天。“人生得意须尽欢！”他大笑着踏月而去，衣袂间尽是酒香与剑气。',
    fx:{ mood:10, cha:5, intl:5, cult:10 } },
  { id:'elf', age:[16,80], w:1, cat:'western', icon:'🧝‍♀️', title:'精灵商人',
    text:() => '月圆之夜，一位尖耳碧眼的精灵商人掀开斗篷，货摊上全是见所未见的奇物。你用一袋灵石换了本《星光咏唱入门》。',
    fx:{ money:-200, intl:6, mood:6 } },
  { id:'bless', age:[10,80], w:1, cat:'western', icon:'✨', title:'圣光赐福',
    text:() => '游方的白袍祭司为你按顶赐福，一道暖流淌过四肢百骸，多年暗伤竟愈合了几分。',
    fx:{ hp:10, karma:8, mood:6 } },
  { id:'fire_lotus', age:[18,60], w:1.2, cat:'treasure', icon:'🔥', title:'异火出世',
    roll:() => {
      const p = 0.35 + (s.talent === 'jianxin' ? 0.2 : 0) + s.intl * 0.002;
      return R() < p
        ? { out:'岩浆湖心，一簇青莲状异火摇曳。你以命相搏将其炼化，焚尽杂质，修为暴涨，隐有异火纹路爬上手背。', fx:{ cult:80, intl:5, hp:-15, mood:10 }, _mark:'炼化异火' }
        : { out:'异火狂暴难驯，反噬而走，你被烈焰燎得重伤，狼狈逃出火口。', fx:{ hp:-25, mood:-8 } };
    } },

  /* ===== 中年 ===== */
  { id:'child_school', age:[28,60], w:5, cat:'family', icon:'🎒', title:'子女开蒙',
    cond:() => s.children.length > 0,
    text:() => '到了子女开蒙的年纪，你咬咬牙备下束脩，送他们进书院。看着小小的背影，你百感交集。',
    fx:{ money:-200, mood:8 } },
  { id:'biz', age:[20,60], w:4, cat:'treasure', icon:'🧾', title:'经营得利',
    cond:() => s.money > 500,
    text:() => '你早前低价囤入的一批灵材恰逢丹会大涨，转手获利颇丰，账本上的数字真好看。',
    fx:{ money:600, mood:6 } },
  { id:'thief', age:[16,80], w:3, cat:'misfortune', icon:'🥷', title:'盗贼夜袭',
    text:() => '深夜梁上君子摸进家中，惊醒的你与之缠斗，虽赶走了贼人，却损失了些财物。',
    fx:{ money:-400, hp:-8, mood:-6 } },
  { id:'boom', age:[20,70], w:2, cat:'misfortune', icon:'💥', title:'炼丹炸炉',
    cond:() => s.intl >= 50,
    text:() => '第一次亲手炼丹，火候差了一分——“轰”的一声，丹炉炸了，满屋子黑烟。',
    fx:{ hp:-10, mood:-8, money:-100 } },
  { id:'oldfriend', age:[30,80], w:3, cat:'family', icon:'🍵', title:'故人来访',
    text:() => '多年未见的老友突然登门，你们喝到深夜，聊起少年往事，笑声震落了梁上灰。',
    fx:{ mood:8 } },
  { id:'rival', age:[20,80], w:3, cat:'sect', icon:'😠', title:'同门倾轧',
    cond:() => s.job && (s.job.includes('弟子') || s.job === '长老'),
    text:() => '同门师兄抢了本该属于你的机缘，还倒打一耙。你据理力争，却寡不敌众。',
    fx:{ mood:-10, cult:-10 } },

  /* ===== 老年 ===== */
  { id:'relapse', age:[55,200], w:5, cat:'misfortune', icon:'💊', title:'旧伤复发',
    text:() => '阴雨天，当年历险留下的旧伤隐隐作痛，你不得不停下一切静养。',
    fx:{ hp:-15, mood:-6 } },
  { id:'friend_die', age:[50,200], w:4, cat:'death', icon:'🕯️', title:'故友仙逝',
    cond:() => s.friends.length > 0,
    text:() => { const f = s.friends[0]; return `噩耗传来，挚友${f ? f : '故人'}坐化了。你扶棺送行，一路无言。`; },
    side:() => { s.friends.shift(); },
    fx:{ mood:-15 } },
  { id:'grandchild', age:[55,200], w:5, cat:'family', icon:'👴', title:'含饴弄孙',
    cond:() => s.children.length > 0,
    text:() => '孙儿缠着你讲当年闯荡的故事，你把“独战妖猪”讲成了“独战妖王”，孩子听得眼睛发亮。',
    fx:{ mood:12 } },
  { id:'decay', age:[60,200], w:4, cat:'cultivate', icon:'🍂', title:'灵力衰退',
    text:() => '你惊觉灵力流转滞涩了几分——岁月这把刀，连修士也躲不过。',
    fx:{ cult:-20, hp:-5 } },
  { id:'enlighten', age:[50,200], w:2, cat:'cultivate', icon:'🌌', title:'澄澈顿悟',
    text:() => '月下独坐，往事如潮水退去，一缕明悟自心底升起：大道至简，原来如此。',
    fx:{ cult:40, mood:10 } },

  /* ===== 灾难 ===== */
  { id:'beasttide', age:[10,90], w:1.5, cat:'battle', icon:'🐉', title:'妖兽袭村',
    roll:() => {
      const p = 0.4 + s.sta * 0.003 + s.realm * 0.07 + (s.talent === 'jianxin' ? TALENTS.jianxin.fightBonus : 0);
      if (R() < p) return { out:'妖狼群扑村之际，你仗剑立于村口，血战一夜，力斩头狼！乡民敲锣打鼓为你披红。', fx:{ cult:20, money:300, hp:-15, mood:8 }, _mark:'力斩头狼' };
      if (R() < 0.06) { die('妖兽袭村，力战而亡'); return { out:'妖狼围困，你力竭不敌……', fx:{}, _kill:true }; }
      return { out:'你拼死护住家小，自己却被妖狼抓得遍体鳞伤，卧床月余。', fx:{ hp:-30, money:-200 } };
    } },
  { id:'sectwar', age:[18,100], w:1.2, cat:'battle', icon:'⚔️', title:'宗门大战',
    cond:() => s.job && (s.job.includes('弟子') || s.job === '长老'),
    roll:() => {
      const p = 0.45 + s.realm * 0.08 + (s.talent === 'jianxin' ? TALENTS.jianxin.fightBonus : 0);
      if (R() < p) return { out:'魔修来犯，山门喋血。你随师兄们布下剑阵，一战功成，名字登上了宗门功勋录。', fx:{ cult:40, mood:10, hp:-20 }, _mark:'宗门血战立功' };
      if (R() < 0.05) { die('殒于宗门大战'); return { out:'魔修攻势如潮，你……', fx:{}, _kill:true }; }
      return { out:'这一战太过惨烈，你重伤垂死，靠一枚保命丹才吊回一条命。', fx:{ hp:-32, mood:-10 } };
    } },
  { id:'fire', age:[12,90], w:1, cat:'misfortune', icon:'🔥', title:'天火焚宅',
    text:() => '一炉香火引发大火，半条街化为焦土。你从火场里抢出几件要紧物什，望着废墟久久无言。',
    fx:{ money:-600, hp:-10, mood:-12 } },
  { id:'heartdemon', age:[25,200], w:2, cat:'cultivate', icon:'👹', title:'心魔缠身',
    cond:() => s.karma <= -40 || (s.realm >= 3 && s.mood < 30),
    text:() => s.karma <= -40
      ? '入夜之后，耳边总有怨语低吟。你平生亏欠之事一一现前，心魔趁虚而入！'
      : '郁结于心，修炼时走火入魔，眼前尽是狰狞幻象。',
    fx:{ hp:-15, mood:-15, cult:-10 } },
  { id:'poison', age:[14,90], w:1, cat:'misfortune', icon:'☠️', title:'中人阴蛊',
    text:() => '一场旧怨未了，你被人在茶里下了阴蛊，又吐又泻了半个月，破财消灾才请灵医拔蛊。',
    fx:{ hp:-15, money:-300, mood:-10 } },

  /* ===== 情缘 ===== */
  /* ===== 情缘 · 七位女主随剧情登场，不预选、不重掷 ===== */
  { id:'enc0', age:[16,50], w:3, cat:'romance', icon:'🏮', title:'灯会惊鸿', enc:0,
    cond:() => !s.lover && s.age >= 16 && (s.gender === 'f' || !metFlag(0)),
    text:() => { setMet(0); const w = encWho(0); return `灯会上人潮如织，一位${w.desc}回眸的瞬间，天地忽然安静了。是${w.name}——${w.style}。`; },
    choices:[
      { t:'上前攀谈', sub:'魅力越高越可能结缘', res:() => {
          const w = encWho(0);
          const p = 0.5 + s.cha * 0.004 + (s.talent === 'lingxi' ? 0.2 : 0);
          if (R() < p) { s.lover = { ...w, fav:50, married:false }; return { out:`你们从灯谜聊到剑法，相谈甚欢。临别时，${w.name}轻声道：“后会有期。”你把这三个字翻来覆去想了一整年。`, fx:{ mood:12, cha:2 }, _mark:`与${w.name}初遇·灯会` }; }
          return { out:'你鼓起勇气上前，却紧张得语无伦次，对方客气地颔首离去。人海茫茫，再无踪迹。', fx:{ mood:-8 } };
        } },
      { t:'悄然离去', sub:'有些人，错过就是一生', res:() => ({ out:'你终究没有上前。灯火阑珊，那道背影消失在长街尽头。', fx:{ mood:-5 } }) },
    ] },
  { id:'enc1', age:[16,60], w:2, cat:'romance', icon:'🗡️', title:'山道遇匪', enc:1,
    cond:() => !s.lover && s.age >= 16 && (s.gender === 'f' || !metFlag(1)),
    text:() => { setMet(1); const w = encWho(1); return `荒僻山道，歹人拦路。千钧一发之际，一骑红尘卷至——是位${w.desc}，长枪挑飞刀客，回眸问你：“可还站得稳？”${w.name}，${w.style}。`; },
    choices:[
      { t:'并肩再战', sub:'体魄强健方显英豪', res:() => {
          const w = encWho(1);
          if (R() < 0.45 + s.sta * 0.003) { s.lover = { ...w, fav:55, married:false }; return { out:`你抄起断棍与TA背靠背而立，残匪一哄而散。${w.name}朗声大笑：“好胆色！改日江湖再会。”那一笑，你记了很多年。`, fx:{ mood:14, sta:2 }, _mark:`与${w.name}并肩退敌` }; }
          return { out:'你挥棍上前却绊了个趔趄，反倒成了被护着的那一个。TA摇头失笑，抱拳而去。', fx:{ mood:-6 } };
        } },
      { t:'连声道谢，目送离去', res:() => ({ out:'你拱手长揖。TA一抱拳，纵马绝尘而去，只留下一个飒爽的背影。', fx:{ mood:4 } }) },
    ] },
  { id:'enc2', age:[30,200], w:2, cat:'romance', icon:'🌫️', title:'秘境邂逅', enc:2,
    cond:() => !s.lover && s.realm >= 3 && (s.gender === 'f' || !metFlag(2)),
    text:() => { setMet(2); const w = encWho(2); return `你在秘境云海中打坐，忽闻环佩轻响。一位${w.desc}踏雾而来，眸光如霜。是${w.name}——${w.style}。TA颔首：“此地灵气尚可，与你共之。”`; },
    choices:[
      { t:'虚心请教大道', sub:'悟性越高越得青眼', res:() => {
          const w = encWho(2);
          if (R() < 0.4 + s.intl * 0.004 + s.gift * 0.003) { s.lover = { ...w, fav:50, married:false }; return { out:`一席论道，如拨云见月。${w.name}眸中微光流转：“你这道心，倒有几分意思。”自此云海之约，岁岁不忘。`, fx:{ cult:30, mood:12 }, _mark:`秘境论道·${w.name}` }; }
          return { out:'TA听了三句便摇头：“根基尚浅。”袖袍一拂，踏雾而去。你望着空荡的云海，怅然若失。', fx:{ mood:-6, cult:10 } };
        } },
      { t:'闭目不视，守心入定', res:() => ({ out:'你不为所动，抱元守一。再睁眼时，云海空空，只余一缕冷香。这一坐，倒是悟了半分清净。', fx:{ cult:20, mood:-2 } }) },
    ] },
  { id:'enc3', age:[18,70], w:2, cat:'romance', icon:'🍇', title:'夜市迷香', enc:3,
    cond:() => !s.lover && (s.gender === 'f' || !metFlag(3)),
    text:() => { setMet(3); const w = encWho(3); return `夜市灯影摇红。一位${w.desc}倚栏而笑，指尖绕着一枚紫玉钏。是${w.name}——${w.style}。“你可为我把把脉，这坊市的酒里，掺了三分迷魂香？”`; },
    choices:[
      { t:'将计就计，陪TA一局', sub:'悟性定输赢', res:() => {
          const w = encWho(3);
          if (R() < 0.45 + s.intl * 0.004) { s.lover = { ...w, fav:48, married:false }; return { out:`你佯饮三杯，袖底银针一试便知。${w.name}眼波流转：“眼光不错——人也不错。”TA把那枚紫玉钏塞进你手里，笑着隐入人潮深处。`, fx:{ money:300, mood:12 }, _mark:`夜市结缘·${w.name}` }; }
          return { out:'你三杯下肚，只觉天旋地转。醒来时钱袋空了一半，那人早已无踪。', fx:{ money:-200, mood:-6 } };
        } },
      { t:'心如止水，摇头而去', res:() => ({ out:'你目不斜视，转身离去。身后传来一声若有似无的叹息：“无趣。”这一晚心神竟分外清明。', fx:{ cult:10, karma:2 } }) },
    ] },
  { id:'enc4', age:[14,90], w:3, cat:'romance', icon:'🌿', title:'病榻之恩', enc:4,
    cond:() => !s.lover && s.hp <= 65 && (s.gender === 'f' || !metFlag(4)),
    text:() => { setMet(4); const w = encWho(4); return `你染了时疫，高热不退。迷糊间药香扑鼻——一位${w.desc}守在榻前喂你汤药。是${w.name}，${w.style}。“莫怕，三帖药就好。”`; },
    choices:[
      { t:'病愈后登门道谢', sub:'礼多人不怪，魅力加分', res:() => {
          const w = encWho(4);
          if (R() < 0.5 + s.cha * 0.004) { s.lover = { ...w, fav:52, married:false }; return { out:`你提着一篮山果登门，${w.name}正低头捣药，抬头一笑，酒窝盛满了春光。此后药庐的门，总为你开着。`, fx:{ mood:14, hp:8 }, _mark:`病中结缘·${w.name}` }; }
          return { out:'你登门道谢，TA只淡淡应了，又埋首药炉。缘分这东西，强求不得。', fx:{ mood:-4, hp:8 } };
        } },
      { t:'留字条致谢，不再叨扰', res:() => ({ out:'你在门上留了字条。数年后路过，药庐已换了主人。你心里空落落的。', fx:{ mood:-5, hp:8 } }) },
    ] },
  { id:'enc5', age:[25,200], w:2, cat:'romance', icon:'👑', title:'仙盟大典', enc:5,
    cond:() => !s.lover && s.realm >= 2 && (s.gender === 'f' || !metFlag(5)),
    text:() => { setMet(5); const w = encWho(5); return `仙盟大典，各方道主齐聚。高台之上，一位${w.desc}凤目轻抬，竟越过满座宾客，在你身上停了一瞬。是${w.name}——${w.style}。“方才论道之人，上前答话。”`; },
    choices:[
      { t:'从容上殿奏对', sub:'悟性与魅力缺一不可', res:() => {
          const w = encWho(5);
          if (R() < 0.35 + s.intl * 0.003 + s.cha * 0.003) { s.lover = { ...w, fav:50, married:false }; return { out:`你纵论大势，字字珠玑。满殿寂然，随后喝彩如雷。${w.name}指尖轻叩高座：“此人之才，当为我仙盟所用——也当为我知己。”`, fx:{ cult:25, mood:14 }, _mark:`殿前奏对·${w.name}` }; }
          return { out:'你紧张之下辞不达意，殿上响起低低嗤笑。TA移开目光，你退下殿来，脸颊滚烫。', fx:{ mood:-8, cult:8 } };
        } },
      { t:'称病推辞', res:() => ({ out:'你称病告罪，躲回了席位。那道凤目扫过来时，你把头埋得极低。机缘这东西，稍纵即逝。', fx:{ mood:-5 } }) },
    ] },
  { id:'enc6', age:[18,80], w:2, cat:'romance', icon:'🌧️', title:'客栈夜雨', enc:6,
    cond:() => !s.lover && (s.gender === 'f' || !metFlag(6)),
    text:() => { setMet(6); const w = encWho(6); return `夜雨敲窗，客栈中你正欲吹灯，忽见窗纸上映出一道受伤的黑影。一位${w.desc}翻窗而入，按着肩头渗血的伤口，冷声道：“借贵处一避，天亮便走。”是${w.name}——${w.style}。`; },
    choices:[
      { t:'撕衣裹伤，守到天明', sub:'善念最动人', res:() => {
          const w = encWho(6);
          if (R() < 0.55 + Math.max(0, s.karma) * 0.002) { s.lover = { ...w, fav:55, married:false }; return { out:`你为TA清创裹伤，燃着灯守到天明。临别时${w.name}深深看了你一眼：“这世上好人不多，你算一个。后会有期。”`, fx:{ karma:6, mood:12 }, _mark:`雨夜援手·${w.name}` }; }
          return { out:'TA接过伤药，自己处理了伤口，天不亮便翻窗而去，只留一句“多谢”。窗外雨声潺潺，像一声叹息。', fx:{ karma:5, mood:-3 } };
        } },
      { t:'佯装熟睡', res:() => ({ out:'你闭目装睡，听着TA压抑的喘息渐渐平息。天亮时分，房中已空。你会记住这个雨夜很久。', fx:{ mood:-6, karma:-2 } }) },
    ] },
  /* ===== 旧识重逢：已邂逅之人再入剧情 ===== */
  { id:'re4', age:[16,200], w:2, cat:'festival', icon:'💊', title:'药师赠丹', enc:4,
    cond:() => s.gender === 'm' && metFlag(4) && (!s.lover || s.lover.pic !== 4),
    text:() => `坊市偶遇${encWho(4).name}，TA的药囊比从前又鼓了几分。见你风尘仆仆，TA塞来两瓶丹药：“拿去，记账上。”`,
    fx:{ hp:12, mood:6 } },
  { id:'re6', age:[18,200], w:2, cat:'battle', icon:'⚔️', title:'故友切磋', enc:6,
    cond:() => s.gender === 'm' && metFlag(6) && (!s.lover || s.lover.pic !== 6),
    text:() => `山道再遇${encWho(6).name}。TA刀意如霜：“那日欠你一伤药，今日以三招相还。”刀光剑影间，你获益良多。`,
    fx:{ cult:25, sta:-5 } },
  { id:'re5', age:[25,200], w:1, cat:'treasure', icon:'📜', title:'仙盟传书', enc:5,
    cond:() => s.gender === 'm' && metFlag(5) && (!s.lover || s.lover.pic !== 5) && s.realm >= 2,
    text:() => `仙盟传书，竟是${encWho(5).name}的亲笔手谕：“闻你修行勤勉，赐灵石百枚，以资大道。”落款处宝印犹温。`,
    fx:{ money:1000, mood:8 } },
  { id:'re2', age:[30,200], w:1, cat:'cultivate', icon:'❄️', title:'故人指点', enc:2,
    cond:() => s.gender === 'm' && metFlag(2) && (!s.lover || s.lover.pic !== 2) && s.realm >= 3,
    text:() => `云海再逢${encWho(2).name}。TA并未多言，只袖袍轻拂，一道清辉没入你眉心——竟是半篇口诀。`,
    fx:{ cult:40, mood:5 } },
  { id:'date', age:[16,80], w:10, cat:'romance', icon:'💝', title:'约会佳期',
    cond:() => s.lover && !s.lover.married,
    text:() => `你与${s.lover.name}泛舟湖上，看落霞与孤鹜齐飞。TA执桨的手很好看，你偷偷记了很多年。`,
    fx:{ mood:10 }, side:() => { s.lover.fav = clamp(s.lover.fav + 10, 0, 100); } },
  { id:'propose', age:[20,80], w:12, cat:'wedding', icon:'🏮', title:'道侣之议',
    cond:() => s.lover && !s.lover.married && s.lover.fav >= 75 && s.age >= 20,
    text:() => `月老祠前，${s.lover.name}眼波流转望着你：“你我相识多年，可愿结为道侣，此后同修共渡？”`,
    choices:[
      { t:'执手结契，结为道侣', sub:'花费500灵石举办道侣大典', show:() => s.money >= 500, res:() => {
          s.lover.married = true;
          return { out:'三书六礼，天地为证。你们于月下互斩青丝结发，自此同修共渡，不离不弃。', fx:{ money:-500, mood:18, karma:3 }, _mark:`与${s.lover.name}结为道侣`, _banner:['marriage','喜结道侣',`${s.name} ❤ ${s.lover.name}`] };
        } },
      { t:'这件大事，容我思量', res:() => ({ out:'你支支吾吾说了些“大道未成”的话。TA笑了笑没说什么，眼里却暗了几分。', fx:{ mood:-4 }, _side:st => { st.lover.fav = clamp(st.lover.fav - 8, 0, 100); } }) },
    ] },
  { id:'shuangxiu', age:[20,200], w:8, cat:'cultivate', icon:'☯', title:'双修共进',
    cond:() => s.lover && s.lover.married,
    text:() => `静室之中，你与道侣${s.lover.name}四掌相抵，灵气在两人经脉间流转成环，如江河交汇。`,
    fx:() => ({ cult: Math.round(12 + s.intl * 0.1), mood:5 }) },
  { id:'birth', age:[20,60], w:8, cat:'family', icon:'👶', title:'添丁之喜',
    cond:() => s.lover && s.lover.married && s.children.length < 4,
    text:() => '产房的啼哭声响彻小院——家里添丁了！你笨手笨脚地抱起那个皱巴巴的小家伙，眼泪一下就下来了。',
    fx:{ money:-300, mood:14 },
    side:() => {
      const nm = s.name[0] + randName().slice(1);
      s.children.push({ name: nm, gender: R() < 0.5 ? 'm' : 'f' });
      mark(`添了一${s.children[s.children.length-1].gender === 'm' ? '子' : '女'}·${nm}`);
    } },
  { id:'parent_ill', age:[32,90], w:8, cat:'family', icon:'🏥', title:'高堂病重',
    cond:() => (s.parents.fa.alive && s.parents.fa.age >= 66) || (s.parents.mo.alive && s.parents.mo.age >= 66),
    text:() => '家中急信：高堂病重，卧床不起。你星夜赶回，看着床上面色蜡黄的老人，喉头哽住。',
    choices:[
      { t:'亲侍汤药，衣不解带', sub:'善恶+ · 父母好感++ · 道心-', res:() => {
          healParent(10);
          return { out:'你守了整整一月，喂药擦身，寸步不离。老人痊愈那日，拉着你的手老泪纵横。', fx:{ money:-400, karma:8, mood:-4 }, _side:st => bumpParentsFav(st, 12) };
        } },
      { t:'重金延请灵医', sub:'灵石-1200 · 父母好感++', show:() => s.money >= 1200, res:() => {
          healParent(25);
          return { out:'重金聘来的灵医妙手回春，高堂转危为安。老人逢人便夸你有出息。', fx:{ money:-1200, karma:4 }, _side:st => bumpParentsFav(st, 15) };
        } },
      { t:'忙于己事，遣人代望', res:() => ({ out:'你只捎回些补品和银钱。老人什么也没说，只是那晚的灯亮了很久。', fx:{ karma:-15, mood:-6 }, _side:st => bumpParentsFav(st, -25) }) },
    ] },

  /* ===== 升迁 ===== */
  { id:'promote_nei', w:30, cat:'sect', icon:'🧗', title:'内门考核',
    cond:() => s.job === '外门弟子' && s.cult >= 280,
    text:() => '三年一度的内门考核将至，执事长老点名让你上场。演武台上，成败在此一举。',
    choices:[
      { t:'全力一搏', res:() => {
          const p = 0.5 + s.cult * 0.0008 + s.intl * 0.003;
          if (R() < p) { s.job = '内门弟子'; return { out:'剑落声起，满场哗然——你胜了！内门玉牌到手，月例翻了近三倍。', fx:{ mood:12, money:200 }, _mark:'升入内门', _banner:['break','晋升内门','宗门玉牌 · 月例八百灵石'] }; }
          return { out:'对手技高一筹，你惜败于最后一合。长老摇头：“再修三年吧。”', fx:{ mood:-10 } };
        } },
      { t:'自忖不稳，弃权', res:() => ({ out:'你在报名处徘徊良久，终究没敢落笔。回房修炼，心里憋着一股劲。', fx:{ mood:-4, cult:8 } }) },
    ] },
  { id:'promote_zc', w:30, cat:'sect', icon:'🏆', title:'真传之选',
    cond:() => s.job === '内门弟子' && s.cult >= 650,
    text:() => '掌门亲临演武场，要在内门弟子中挑选真传，亲授镇宗功法。你深吸一口气，踏上了高台。',
    choices:[
      { t:'登台竞艺', res:() => {
          const p = 0.45 + s.cult * 0.0006 + s.intl * 0.003;
          if (R() < p) { s.job = '真传弟子'; return { out:'掌门抚须大笑：“好！此子可为真传！”你跪领镇宗玉简，满门瞩目。', fx:{ mood:15, money:500 }, _mark:'选为真传弟子', _banner:['break','真传弟子','得授镇宗功法'] }; }
          return { out:'一位师姐技压全场，你名列第二。掌门道：“来日方长。”你恭敬退下，掌心全是汗。', fx:{ mood:-8, cult:15 } };
        } },
      { t:'让贤不出', res:() => ({ out:'你觉得时机未到，主动让贤。同门赞你气度，你自己知道，是怕了。', fx:{ mood:-5, karma:2 } }) },
    ] },
  { id:'promote_elder', w:20, cat:'sect', icon:'🗿', title:'长老之位',
    cond:() => s.job === '真传弟子' && s.age >= 50 && s.cult >= 1200,
    text:() => '议事殿传讯：宗门议定，授你长老之位，入主一峰。数十年苦修，终成人上之人。',
    choices:[
      { t:'接任长老', res:() => { s.job = '长老'; return { out:'你披上长老法袍，入主青莲峰。当日，全宗弟子上山道贺，盛况空前。', fx:{ mood:15, money:1000 }, _mark:'就任宗门长老', _banner:['break','一峰长老','入主青莲峰'] }; } },
      { t:'婉拒闲云', res:() => ({ out:'你笑辞长老之位，只求一间静室自在修行。掌门深感其志，赐下丹药。', fx:{ cult:30, mood:8 } }) },
    ] },
  { id:'m_shanghu', at:32, cat:'treasure', icon:'🏬', title:'商途之择',
    cond:() => s.job === '账房' && s.money > 1500,
    text:() => '这些年攒下些家底，东家劝你：“账房做得再好也是替人数钱，何不自己开间铺面？”',
    choices:[
      { t:'辞工开铺，下海从商', res:() => { s.job = '掌柜'; return { out:'你盘下坊市一角开了间小铺，起早贪黑。头一年虽辛苦，进项却比账房翻了几倍。', fx:{ money:-1000, mood:8 }, _mark:'自立门户为掌柜' }; } },
      { t:'安稳度日', res:() => ({ out:'你婉拒了东家好意。铁算盘一响，岁月安稳，也波澜不惊。', fx:{ mood:4 } }) },
    ] },
];

/* ===== 三维枯竭事件 ===== */
EVENTS.push(
  { id:'drain_sta', age:[8,200], w:6, cat:'misfortune', icon:'😵', title:'力竭昏倒',
    cond:() => s.sta < 12,
    text:() => '连日的劳碌终于压垮了你。眼前一黑，你直挺挺栽倒在地——醒来已是三日之后，浑身像被车碾过一遍。',
    fx:{ hp:-10, mood:-6, sta:10 }, wmul:() => s.sta < 6 ? 2.4 : 1 },
  { id:'drain_mood', age:[12,200], w:6, cat:'cultivate', icon:'👹', title:'心魔丛生',
    cond:() => s.mood < 12,
    text:() => '夜半入定，识海里翻涌起无数张脸：讥讽你的、怜悯你的、期盼你的……它们齐声质问——“你修这仙，究竟图什么？”冷汗浸透了道袍。',
    choices:[
      { t:'以痛入定，强行镇压', sub:'修为损耗，道心暂稳', res:() => ({ out:'你咬破舌尖，以剧痛拴住心神，硬生生把杂念压回识海深处。天明时，你像老了十岁。', fx:{ hp:-8, mood:9 }, _side:st => { st.cult = Math.max(0, st.cult - 20); } }) },
      { t:'下山寻欢，借酒消愁', sub:'道心大涨，囊中见底', res:() => ({ out:'你在坊市最热闹的酒楼喝到天明，醉里不知身是客。醒来钱袋空了一半，心里的石头却轻了些。', fx:{ mood:18, money:-250, sta:-6 } }) },
      { t:'闭关诵经，与自己和谈', sub:'最慢，却最稳', res:() => ({ out:'你焚香净手，把《清静经》抄了百遍。写到最后，那些声音不知不觉散了。', fx:{ mood:13, intl:3, karma:2, sta:-8 } }) },
    ] },
  { id:'drain_hp', age:[6,200], w:7, cat:'death', icon:'🩸', title:'病入膏肓',
    cond:() => s.hp < 18,
    text:() => '你已经咳了半个月，痰中带血。郎中把完脉，一言不发地摇头。屋外风声呜咽，像谁在低声唤你的名字。',
    choices:[
      { t:'倾家荡产求一颗续命丹', sub:'灵石 -800，气血大补', show:() => s.money >= 800,
        res:() => ({ out:'你砸出全部积蓄换来一枚赤红丹药。丹入喉，四肢百骸如春水回潮——这条命，算是抢回来了。', fx:{ money:-800, hp:35, mood:5 }, _mark:'重金续命' }) },
      { t:'硬扛过去，不信这个命', sub:'九死一生', res:() => (R() < 0.5
          ? { out:'你在鬼门关前晃了一圈，竟真扛了过来。只是从此落下病根，气力大不如前。', fx:{ hp:14, sta:-12 } }
          : { out:'你终究没能扛住。浑身高热不退，恍惚间想起还有很多事没做完。', fx:{ hp:-30, mood:-12 } }) },
      { t:'散去修为，闭死关调息', sub:'以修为换性命', res:() => ({ out:'你封了气海，以龟息之法闭关三年。出关时形销骨立，脸色却红润了些。', fx:{ hp:24, sta:12 }, _side:st => { st.cult = Math.max(0, st.cult * 0.6); }, _mark:'散功保命' }) },
    ] }
);


/* ---------------- 抉择里程碑 ---------------- */
const MILESTONES = [
  { age:6,  id:'m_awaken' },
  { age:7,  id:'m_school' },
  { age:12, id:'m_explore' },
  { age:15, id:'m_firstlove', cond:() => !s.lover },
  { age:18, id:'m_path' },
  { age:22, id:'m_exam22', cond:() => s.job === '书院学士' },
  { age:22, id:'m_nei22',  cond:() => s.job === '杂役弟子' },
  { age:25, id:'m_tuihun', cond:() => !s.lover && !s.flags.tuihun && (s.root === 'wei' || s.money < 300) && R() < 0.85 },
  { age:30, id:'m_30' },
  { age:36, id:'m_family36', cond:() => s.lover || s.children.length > 0 },
  { age:45, id:'m_45' },
  { age:55, id:'m_55', cond:() => s.children.length > 0 },
  { age:60, id:'m_60' },
];

const CHOICE_EVENTS = {
  m_awaken: { cat:'sect', icon:'☯', title:'灵根觉醒大典',
    text:() => `六岁，青云宗测灵大典。你把手按上测灵石，石中光华流转——竟是${ROOTS[s.root].name}！四下议论声嗡然而起。${ROOTS[s.root].desc}。`,
    choices:[
      { t:'全力施展，锋芒毕露', res:() => { s.rootKnown = true; return { out:'你毫不收敛，灵光冲天而起。主持长老抚须而笑，当场记下你的名字。', fx:{ intl:3, cha:3, cult:10 }, _mark:`灵根觉醒·${ROOTS[s.root].name}` }; } },
      { t:'藏拙守愚，静待天时', res:() => { s.rootKnown = true; return { out:'你只露出三分灵光。几位长老对视一眼，似笑非笑：“此子……有点意思。”', fx:{ mood:3, karma:2, intl:2 }, _mark:`灵根觉醒·${ROOTS[s.root].name}（藏拙）` }; } },
    ] },
  m_school: { cat:'school', icon:'🎒', title:'开蒙入学',
    text:() => s.origin === 'pin' ? '家里砸锅卖铁凑齐束脩，把你送进了村塾。娘说：“咱家就指望你了。”'
      : s.origin === 'shijia' ? '你入了家学，开篇第一课是《引气诀》。族中长辈亲授，同窗皆是世家子弟。'
      : '你进了镇上的书院，笔墨纸砚一应俱全。先生抚须道：“既入学，便要读出个人样来。”',
    choices:[
      { t:'闻鸡起舞，刻苦攻读', res:() => ({ out:'从此鸡鸣即起，三更方歇。同窗戏称你“书呆”，先生却赞你“可造之材”。', fx:{ intl:5, mood:-3 }, _side:st => { st.job = '书院学子'; } }) },
      { t:'顽劣逃学，山中撒野', res:() => {
          s.job = '书院学子';
          if (R() < 0.3) return { out:'逃学路上误入一处野瀑，水潭底竟沉着半卷古经！你如获至宝，偷偷读了半宿。', fx:{ mood:6, cult:10 }, _mark:'逃学偶得古经' };
          return { out:'掏鸟窝、斗蛐蛐、下河摸鱼，快活了小半年，直到先生的戒尺找上门来。', fx:{ mood:6, intl:-2, sta:3 } };
        } },
    ] },
  m_explore: { cat:'treasure', icon:'🌲', title:'后山之约',
    text:() => '同窗相传：后山古洞里有前朝修士遗留的宝藏。他们怂恿你同去，洞口黑黢黢的，不知深浅。',
    choices:[
      { t:'深入古洞探宝', sub:'机缘与危险并存', res:() => {
          if (R() < 0.45 + s.sta * 0.002) return { out:'洞中岔路尽头，你摸到一只锈迹斑斑的铁匣——里面是三十块灵石和一本《吐纳初解》！', fx:{ money:300, cult:12, intl:3 }, _mark:'古洞得宝' };
          return { out:'洞中突然塌方！你抱头狂奔，被落石砸中后背，宝没捞着，命大捡回一条。', fx:{ hp:-18, mood:-6 } };
        } },
      { t:'安稳在家读书', res:() => ({ out:'你婉拒了同窗，在家温书。数月后听说那洞里伤了两个人，你后怕不已，书却读得更踏实了。', fx:{ intl:3 } }) },
    ] },
  m_firstlove: { cat:'romance', icon:'💮', title:'情窦初开', enc:0,
    text:() => { setMet(0); const w = encWho(0); return `青梅巷口那位${w.desc}又大了一岁，眉眼长开了，笑起来像春水初生。是邻家的${w.name}。你远远看着，心跳如鼓。`; },
    choices:[
      { t:'红着脸递上桃花笺', res:() => {
          const w = encWho(0);
          const p = 0.45 + s.cha * 0.004 + (s.talent === 'lingxi' ? 0.2 : 0);
          if (R() < p) { s.lover = { ...w, fav:55, married:false }; return { out:`${w.name}接过花笺，耳根悄悄红了：“……我知道了。”从此你俩之间，连风都是甜的。`, fx:{ mood:15, cha:2 }, _mark:`与${w.name}两小定情` }; }
          return { out:'花笺被原样退回，上面多了一行小字：“学业为重。”你把脸埋进了被子里。', fx:{ mood:-10 } };
        } },
      { t:'把心思埋进书里', res:() => ({ out:'你把那点心事折成纸船放进河里，看着它漂远。此后埋头苦读，只是偶尔会想起那个笑。', fx:{ intl:4, mood:-2, cult:8 } }) },
    ] },
  m_path: { cat:'sect', icon:'⛩️', title:'命运十字路口',
    text:() => '十八岁，站在人生的岔路口。宗门大比的告示、科举的锣鼓、商队的驼铃，三条路在眼前铺开。',
    choices:[
      { t:'投身仙门，向道而行', sub:'修为/资质达标可入外门', res:() => {
          if (s.root === 'wei' && s.cult < 80 && s.intl < 60) { s.job = '杂役弟子'; return { out:'大比首轮即遭淘汰。执事看你可怜，收你做了杂役弟子：劈柴、挑水、扫地，月例微薄。你咬牙收下——“且看今后。”', fx:{ cult:10, mood:-6 }, _mark:'入宗为杂役' }; }
          s.job = '外门弟子';
          return { out:'大比场上你灵光乍现，惊起四座！执事长老当场点头，外门玉牌挂上了腰间。', fx:{ cult:20, mood:10 }, _mark:'拜入青云宗外门' };
        } },
      { t:'科举入仕，庙堂之志', sub:'悟性达标走读书路线', res:() => {
          if (s.intl >= 60) { s.job = '书院学士'; return { out:'你顺利过了县试，得了“童生”功名。先生大喜：“来年秋闱，必有你的名字！”', fx:{ intl:5, mood:8 }, _mark:'科举入童生' }; }
          s.job = '账房';
          return { out:'文章平平，县试落榜。你辗转进了家商铺做账房，笔杆子换成了算盘珠。', fx:{ mood:-6, intl:2 }, _mark:'科举落榜，从商为账房' };
        } },
      { t:'继承家业，行走凡尘', res:() => { s.job = '学徒'; return { out:'你随长辈学做买卖，秤杆子一提一放都是学问。日子踏实，烟火气十足。', fx:{ money:500, cha:3, sta:3 }, _mark:'继承家业从商' }; } },
    ] },
  m_exam22: { cat:'school', icon:'🎓', title:'秋闱放榜',
    text:() => '秋闱放榜之日，贡院外人山人海。你挤到榜前，手心全是汗。',
    choices:[
      { t:'抬头看榜', res:() => {
          if (s.intl >= 75) { s.job = '县令'; return { out:'榜首之上，赫然是你的名字！雁塔题名，琼林赴宴，县令官身加冕。街坊奔走相告：“咱家出了位父母官！”', fx:{ money:1000, cha:5, mood:15 }, _mark:'金榜题名任县令', _banner:['break','金榜题名','县令官身 · 光宗耀祖'] }; }
          return { out:'从头到尾找不到自己的名字。你失魂落魄地回到家，把笔搁了三天，第四天又拿了起来。', fx:{ mood:-12, intl:3 }, _side:st => { st.job = '账房'; } };
        } },
    ] },
  m_nei22: { cat:'sect', icon:'🧗', title:'杂役的转身',
    text:() => '宗门杂役也有转正之机——外门补录考核开考。你放下水桶，攥紧了拳。',
    choices:[
      { t:'参加考核', res:() => {
          const p = 0.45 + s.cult * 0.001 + s.sta * 0.002;
          if (R() < p) { s.job = '外门弟子'; return { out:'三年挑水，臂力惊人；五年扫地，步法自成。你赢了所有人对你的轻视。', fx:{ mood:12 }, _mark:'杂役转外门弟子' }; }
          return { out:'差之毫厘。执事叹道：“明年再来。”你回到柴房，把斧头抡得更狠了。', fx:{ mood:-8, sta:3, cult:5 } };
        } },
      { t:'继续做杂役', res:() => ({ out:'你摇摇头回到柴房。火光里，那本翻烂的功法还在。', fx:{ cult:8 } }) },
    ] },
  m_tuihun: { cat:'misfortune', icon:'💔', title:'退婚之辱',
    text:() => '锦衣华服的仙子携退婚书登门：“你我婚约，就此作废。”满堂寂静，所有目光扎在你背上。',
    choices:[
      { t:'莫欺少年穷！', res:() => { s.flags.tuihun = true; return { out:'你一字一句道：“三十年河东，三十年河西，莫欺少年穷！”当场撕了退婚书。从此你修炼，比谁都狠。', fx:{ cult:30, mood:-5 }, _mark:'受退婚之辱，立誓自强' }; } },
      { t:'默然受下', res:() => { s.flags.tuihun = true; return { out:'你默默在退婚书上按了手印。那晚你一个人喝了半壶闷酒，天亮照常砍柴。', fx:{ mood:-12, karma:2 } }; } },
      { t:'拂袖而去', res:() => { s.flags.tuihun = true; return { out:'“请回吧。”你转身出门，头也不回。往后十年，你再没提过这一日。', fx:{ mood:6, cha:-3, karma:-5 } }; } },
    ] },
  m_30: { cat:'cultivate', icon:'⛰️', title:'而立之年',
    text:() => '三十而立。你于山巅静坐一夜：此后经年，该往何处去？',
    choices:[
      { t:'闭关苦修，向道之心不改', res:() => ({ out:'你散去外务，闭关百日。出关那日，气息浑然一新。', fx:{ cult:40, mood:-8 } }) },
      { t:'广结善缘，行走人间', res:() => ({ out:'你游历四方，扶危济困，结识豪杰无数。酒喝了很多，路走了很远。', fx:{ cha:5, karma:8, mood:8 }, _side:st => { if (st.friends.length < 9) st.friends.push(randName()); } }) },
      { t:'及时行乐，浮生偷闲', res:() => ({ out:'这一年你哪儿也没去，吃遍坊市，听遍小曲。人间烟火，最抚人心。', fx:{ money:-300, mood:12 } }) },
    ] },
  m_family36: { cat:'family', icon:'🏠', title:'肩上的担子',
    text:() => '上有高堂渐老，下有儿女绕膝，你中年的肩膀，一头挑家，一头挑道。',
    choices:[
      { t:'为家人挣命，多接任务', res:() => ({ out:'你拼命接活儿攒灵石，回家时总带些小玩意。家人笑语盈盈，你却添了几缕白发。', fx:{ money:800, hp:-10, mood:6 } }) },
      { t:'放下杂务，陪伴左右', res:() => ({ out:'你推了许多应酬，陪高堂晒太阳，教儿女练字。灯下团圆饭，胜过十年功。', fx:{ mood:12, karma:5 }, _side:st => bumpParentsFav(st, 10) }) },
    ] },
  m_45: { cat:'cultivate', icon:'🚪', title:'瓶颈之关',
    text:() => '修为滞涩已有数年，坊间传闻：闭死关搏一把，或是入红尘炼心，二者取一。',
    choices:[
      { t:'闭死关，不破境不出关', res:() => {
          if (R() < 0.55) return { out:'石室三百日，你如枯木；一朝雷动，关破！多年桎梏一朝得解。', fx:{ cult:80, hp:-10 }, _mark:'死关得破' };
          return { out:'死关三百日，你伤及根基，被人抬出石室。道友摇头：“太刚了。”', fx:{ hp:-20, mood:-10, cult:10 } };
        } },
      { t:'入红尘炼心', res:() => ({ out:'你在市井开茶摊三年，迎来送往，听尽人间悲欢。某日擦桌子时忽然笑了——道，原来在这儿。', fx:{ cult:25, cha:5, mood:10, karma:5 } }) },
    ] },
  m_55: { cat:'family', icon:'📜', title:'传承之择',
    text:() => '儿女已成，你的功法、积攒的人脉与灵石，传下去，还是自用？',
    choices:[
      { t:'倾囊传承给儿女', res:() => ({ out:'你把毕生所悟整理成册，逐字教给儿女。看着他们青出于蓝，你比自家突破还高兴。', fx:{ mood:12, karma:8 }, _mark:'传承衣钵于儿女' }) },
      { t:'自己还要再搏一程', res:() => ({ out:'“我的道，还没走完。”你把功法锁回匣中，转身入了静室。儿女眼中，你既遥远又令人敬佩。', fx:{ cult:30, mood:4 } }) },
    ] },
  m_60: { cat:'death', icon:'🌕', title:'回望来路',
    text:() => '耳畔风吹过山岗，你忽然意识到：来路已经比去路长了。',
    choices:[
      { t:'含笑回望，此生无憾', res:() => ({ out:`你翻出泛黄的旧物，一件件细看。想起${s.lover ? `道侣${s.lover.name}` : '那些散落天涯的人'}，想起走过的路，你笑了笑：值了。`, fx:{ mood:15 }, _side:st => { st.flags.lifeBonus = (st.flags.lifeBonus || 0) + 5; } }) },
      { t:'不服老，最后一搏', res:() => ({ out:'你熬干灯油般苦修一年。旁人叹你不识时务，你只道：向死而生，方是修士。', fx:{ cult:50, hp:-12, mood:-5 } }) },
    ] },
};

/* 突破 / 飞升事件 */
function makeBreakthrough(nr) {
  const isTrib = s.realm === 6; // 渡劫 → 大乘，需渡天劫
  return {
    isBreak: true, cat:'cultivate', icon:'⚡', title: isTrib ? '天劫将至' : '突破契机',
    text: () => isTrib
      ? `九霄之上劫云汇聚，紫电如龙。你盘坐劫云之下，衣袂猎猎——渡此劫，则入大乘，仙凡两隔。`
      : `灵气如潮，周身窍穴齐鸣——突破${nr.name}的契机到了！机不可失，风险亦存。`,
    choices: [
      { t: isTrib ? '迎劫而上' : '全力冲关', res: () => {
          let p = 0.5 + ROOTS[s.root].bp + s.intl * 0.002 + s.hp * 0.002 + s.gift * 0.003 + (s.talent === 'daoti' ? 0.06 : 0) - Math.max(0, s.age - curSpan() * 0.6) * 0.0015;
          if (isTrib) p *= 0.62;
          p = clamp(p, 0.12, 0.92);
          if (R() < p) {
            s.realm += 1; s.cult -= nr.need;
            mark(`突破${REALMS[s.realm].name}`);
            showBanner('break', `境界突破`, `${REALMS[s.realm].name} · 寿元增至${curSpan()}载`);
            return { out:`雷声敛去，天地清明的刹那，你周身光华流转——${REALMS[s.realm].name}！从此寿元大增，脱胎换骨。`, fx:{ mood:15, hp:5 }, _mark:null };
          }
          if (isTrib && R() < 0.55) { die('渡劫失败，形神俱灭'); return { out:'第九道天雷落下，你的护体灵光如纸般碎裂……', fx:{}, _kill:true }; }
          return { out:`冲关失败！灵气逆冲经脉，你喷出一口逆血，跌坐原地。差之毫厘，只当是道心磨砺。`, fx:{ hp:-12, mood:-8, cult:-Math.round(nr.need * 0.12) } };
        } },
      { t:'稳一稳，继续积淀', res:() => ({ out:'你按住躁动的灵气，选择继续积淀。来日方长，稳字当头。', fx:{ mood:2, cult:10 } }) },
    ],
  };
}
function makeAscend() {
  return {
    isBreak: true, cat:'cultivate', icon:'🌈', title:'飞升之门',
    text:() => '功行圆满，天门自开。云海之上金桥横跨，仙乐隐隐——飞升之机，一生只有这一次。',
    choices:[
      { t:'白日飞升，位列仙班', res:() => { s.won = true; die('白日飞升，位列仙班', true); return { out:'你踏上金桥，回首人间最后一眼。云海翻涌处，一世浮生，圆满收官。', fx:{}, _kill:true, _banner:['ascend','白日飞升','浮生圆满 · 位列仙班'] }; } },
      { t:'留恋红尘，再会一会', res:() => { s.flags.lifeBonus = (s.flags.lifeBonus || 0) + 120; s.flags.refusedAscend = true; return { out:'你转身走下金桥。天门在你的背影后缓缓合拢——人间还有放不下的人和事，那便再走一程。', fx:{ mood:10, karma:10 }, _mark:'拒绝飞升，留恋红尘' }; } },
    ],
  };
}

/* ---------------- 行为 ---------------- */
const ACTIONS = [
  { id:'cultivate', ic:'🧘', name:'修炼', tip:'修为↑ 精力↓', show:() => s.rootKnown },
  { id:'study', ic:'📖', name:'学习', tip:'悟性↑ 精力↓', show:() => true },
  { id:'work', ic:'⚒️', name:'打工', tip:'灵石↑ 精力道心↓', show:() => s.age >= 14 },
  { id:'train', ic:'⚔️', name:'运动', tip:'气血精力↑', show:() => true },
  { id:'social', ic:'🍶', name:'社交', tip:'魅力↑ 或遇良缘', show:() => s.age >= 8 },
  { id:'rest', ic:'😴', name:'休息', tip:'气血道心↑', show:() => true },
  { id:'splurge', ic:'🛍️', name:'挥霍', tip:'灵石↓ 道心↑↑', show:() => s.money >= 200 },
];
function applyAction(id) {
  const t = TALENTS[s.talent];
  let chips = [];
  if (id === 'cultivate') {
    let gain = 6 + s.intl * 0.12 + s.gift * 0.2 + (s.origin === 'shijia' ? 2 : 0);
    gain *= ROOTS[s.root].mul * (t.cultMul || 1) * (1 + s.gift * 0.006);
    if (s.lover && s.lover.married) gain *= 1.2;
    if (s.age > curSpan() * 0.85) gain *= 0.5;
    gain *= drainMul('cultivate');
    gain = Math.max(1, Math.round(gain));
    const fx = { cult: gain, sta: -10, mood: -2 };
    const jh = s.hp < DRAIN.hp ? 0.35 : 0.12;
    if (s.hp < Math.max(25, DRAIN.hp) && R() < jh) { fx.hp = -15; log('走火入魔！气血逆冲，你险些伤及根基。', 'doom'); }
    if (s.sta < DRAIN.sta) { fx.hp = (fx.hp || 0) - 6; log('精力早已透支，仍强行运功，五脏如焚。', 'doom'); }
    if (s.mood < DRAIN.mood) log('心绪烦乱，灵气滞涩，这一坐终究是散了。', 'doom');
    chips = applyFx(fx);
    log(`【修炼】${s.name}盘膝入定，吐纳周天，灵气沿经脉缓缓流转。`, 'act');
  } else if (id === 'study') {
    const dms = drainMul('study');
    let gain = (2 + R() * 2) * (s.age <= 22 ? 1.6 : 1) * (t.studyMul || 1);
    gain *= dms;
    gain = Math.max(1, Math.round(gain));
    chips = applyFx({ intl: gain, sta: -6, mood: -1 });
    log('【学习】青灯古卷，字字入心。', 'act');
    if (dms < 0.9) log('神思倦怠，书上的字一个也读不进去。', 'doom');
  } else if (id === 'work') {
    let gain = 60 + s.age * 6 + s.intl * 1.5 + (SALARY[s.job] ? SALARY[s.job] * 0.1 : 0);
    gain = Math.round(gain * (0.85 + R() * 0.3) * drainMul('work'));
    chips = applyFx({ money: gain, sta: -12, mood: -4 });
    log(`【打工】${s.job && s.job.includes('弟子') ? '接宗门杂务' : '在坊市做工'}，风里来雨里去，攒下${fmt(gain)}灵石。`, 'act');
    if (R() < 0.1) { chips.push(...applyFx({ hp: -10 })); log('劳作时不慎伤了筋骨。', 'doom'); }
    if (s.sta < DRAIN.sta) { chips.push(...applyFx({ hp: -5 })); log('强撑着干完活，回屋便瘫在了床上。', 'doom'); }
    if (s.hp < DRAIN.hp && R() < 0.2) { chips.push(...applyFx({ hp: -8 })); log('本就病着，一场劳作下来险些晕倒。', 'doom'); }
  } else if (id === 'train') {
    const weak = s.hp < DRAIN.hp;
    chips = applyFx({ hp: weak ? 1 : (s.talent === 'tiruo' ? 2 : 4), sta: weak ? 3 : 8, mood: 1 });
    log('【运动】迎着朝阳吐故纳新，筋骨活络，气血充盈。', 'act');
    if (weak) log('拖着病体勉强活动，收效甚微——还是先养好伤要紧。', 'doom');
  } else if (id === 'social') {
    const gain = Math.max(1, Math.round((2 + R() * 2) * (t.socMul || 1) * drainMul('social')));
    chips = applyFx({ cha: gain, mood: 3 });
    log('【社交】赴茶楼酒肆谈天说地，人脉渐广。', 'act');
    if (s.mood < DRAIN.mood) log('你强颜欢笑了一整场，散席时只觉得更累了。', 'doom');
    if (!s.lover && s.age >= 16 && R() < 0.1 + s.cha * 0.002 + (t.socMul ? 0.08 : 0)) {
      const free = HEROINES.map((h, i) => i).filter(i => !metFlag(i));
      const w = s.gender === 'f' ? meetPerson() : (free.length ? encWho(pick(free)) : null);
      if (w) {
        if (s.gender === 'm') setMet(w.pic);
        s.lover = { ...w, fav: 45, married: false };
        log(`席间一位${w.desc}与你相谈甚欢——竟是${w.name}！别时，你心跳难平。`, 'ev');
        mark(`与${w.name}相识`);
      } else {
        const nm = randName(); s.friends.push(nm);
        log(`结识新友${nm}，把酒言欢。`, 'ev');
        chips.push(...applyFx({ mood: 4 }));
      }
    } else if (R() < 0.25 && s.friends.length < 9) {
      const nm = randName(); s.friends.push(nm);
      log(`结识新友${nm}，把酒言欢。`, 'ev');
      chips.push(...applyFx({ mood: 4 }));
    }
  } else if (id === 'rest') {
    const dh = s.hp < DRAIN.hp ? 5 : 0, dm = s.mood < DRAIN.mood ? 6 : 0, ds = s.sta < DRAIN.sta ? 10 : 0;
    chips = applyFx({ hp: 6 + dh, mood: 6 + dm, sta: 15 + ds });
    log('【休息】煮一壶灵茶，安枕无忧。', 'act');
    if (dh || dm || ds) log('好好将养了一场，元气渐复。', 'good');
  } else if (id === 'splurge') {
    chips = applyFx({ money: -200, mood: 10 });
    log('【挥霍】逛遍坊市，眼花缭乱，买到心爱之物，快活似神仙。', 'act');
    const r = R();
    if (r < 0.15) { chips.push(...applyFx({ intl: 3 })); log('淘到的旧书里竟夹着一份心得，赚到！', 'good'); }
    else if (r < 0.25) { chips.push(...applyFx({ mood: -6 })); log('回来越看越觉得买亏了，肉疼。', 'doom'); }
  }
  const dw = drainWarns();
  if (dw.length) log(`⚠ 状态告急：${dw.join('、')}——宜早做将养。`, 'doom');
  logChips(chips);
}


/* =========================================================
   行为专属事件：学习 / 运动 / 休息 / 修炼 / 打工 / 社交 各自不同
   ========================================================= */
const ACTION_EVENTS = {
  /* ---------- 学习 ---------- */
  study: [
    { id:'st_poem', age:[12,70], w:6, cat:'school', icon:'🖌', title:'诗会夺魁',
      text:() => '城中诗会，彩楼高悬，众人各展所长。你提着笔，纸上落下的第一个字会是什么？',
      choices:[
        { t:'以剑气入诗，锋芒毕露', res:() => ({ out:'你落笔如出剑，一句“十年磨一剑，霜刃未曾试”掷地有声。满堂皆静，继而喝彩如雷。有人记下了你的名字。', fx:{ intl:4, cha:5, mood:6 }, _mark:'诗会夺魁' }) },
        { t:'以情入诗，含蓄蕴藉', res:() => ({ out:'你写的是母亲灯下缝衣的背影。评委中一位老者红了眼眶，把一方旧砚赠给了你。', fx:{ intl:5, mood:5, cha:2, money:120 } }) },
        { t:'重金请人代笔', res:() => (R() < 0.45
            ? { out:'代笔之作果然夺了魁。你捧着赏银，心里却空落落的——那首诗，你一个字都想不起来。', fx:{ cha:5, money:400, karma:-7, mood:-3 } }
            : { out:'代笔之事当众败露。你被轰出彩楼，从此在同窗面前抬不起头。', fx:{ cha:-7, mood:-9, karma:-5 } }) },
      ] },
    { id:'st_oldbook', age:[10,80], w:5, cat:'treasure', icon:'📜', title:'残卷之谜',
      text:() => '旧书摊上压着半卷焦黑的册子，摊主当废纸卖。你翻了两页，指尖一颤——这是失传的吐纳法门。',
      choices:[
        { t:'高价买下', res:() => ({ out:'你掏空钱袋换回残卷。此后三月，你按图索骥，修为进境之快令同门侧目。', fx:{ money:-320, intl:6, cult:18 } }) },
        { t:'蹲在摊前抄录', res:() => ({ out:'你抄到一半，摊主回过神来把册子收走了。好在关键几句已落在纸上。', fx:{ intl:4, sta:-8, mood:-2 } }) },
        { t:'记下位置，夜里来取', res:() => (R() < 0.4
            ? { out:'三更天你翻墙入院，残卷果然还在。你心跳如鼓，却也知道这一夜是自己选的路。', fx:{ intl:6, cult:24, karma:-5, sta:-6 } }
            : { out:'夜里摊子早收了，你守到天亮也没见着人。回来的路上，你把这事当成了笑话讲给自己听。', fx:{ mood:-5, sta:-6 } }) },
      ] },
    { id:'st_teacher', age:[6,26], w:5, cat:'school', icon:'🧓', title:'严师',
      text:() => '先生今日格外严厉，戒尺敲在案上啪啪作响：“这句，你再解一遍。”',
      choices:[
        { t:'俯首受教', res:() => ({ out:'你规规矩矩重解一遍，先生听完只“嗯”了一声。放学后他却单独留下你，讲到了掌灯时分。', fx:{ intl:6, mood:-3, sta:-6 } }) },
        { t:'当面顶撞', res:() => ({ out:'你把书一合，说了句“弟子不服”。先生愣了半晌，忽然大笑：“好，总算有个敢说话的。”', fx:{ intl:-2, mood:5, cha:3, karma:-2 } }) },
        { t:'偷学他的独门解法', res:() => ({ out:'你趁他打盹，把他压在镇纸下的批注背了个滚瓜烂熟。此后解同类题，你比谁都快。', fx:{ intl:8, sta:-8, karma:-1 } }) },
      ] },
    { id:'st_library', age:[14,80], w:4, cat:'sect', icon:'📚', title:'藏经阁夜读',
      cond:() => s.job && s.job.includes('弟子'),
      text:() => '藏经阁三层，灯火昏黄。执事打着哈欠锁了门，而你还在书架之间。',
      choices:[
        { t:'通宵抄录', res:() => ({ out:'你抄到鸡鸣，手指僵得握不住笔。怀里的纸却沉甸甸的。', fx:{ intl:5, sta:-12, cult:12 } }) },
        { t:'翻看禁书区的典籍', res:() => (R() < 0.5
            ? { out:'禁书里记载的速成法门霸道无比。你照着练了一夜，修为暴涨，胸口气血却翻涌不止。', fx:{ cult:42, intl:4, hp:-14, karma:-3 } }
            : { out:'你刚抽出那册书，身后传来执事的咳嗽声。第二日，你被罚抄《清规》百遍。', fx:{ hp:-8, mood:-7, sta:-6 } }) },
        { t:'帮执事整理书架', res:() => ({ out:'你把散乱的典籍一一归位。执事次日见了，塞给你一袋灵石说是“辛苦费”。', fx:{ cha:4, mood:-2, money:120 } }) },
      ] },
    { id:'st_debate', age:[16,80], w:4, cat:'cultivate', icon:'🗣', title:'论道辩难',
      text:() => '有游方修士在坊市摆下论道台，连败七人，扬言此地无人。台下人推你上去。',
      choices:[
        { t:'引经据典，稳扎稳打', res:() => ({ out:'你引三部经典层层反驳，对方答不上来，拱手认输。围观众人啧啧称奇。', fx:{ intl:4, cha:3, mood:4 } }) },
        { t:'以己证道，现身说法', res:() => ({ out:'你不引经文，只讲自己引气时的体悟。说到深处，灵台竟一片澄明——这一讲，你自己的道也清晰了几分。', fx:{ intl:3, cult:14, mood:5 } }) },
        { t:'拱手认输，虚心请教', res:() => ({ out:'你坦言自己学浅，请他赐教。他反倒不好意思起来，与你彻夜长谈。', fx:{ intl:5, cha:-2, mood:3, karma:2 } }) },
      ] },
    { id:'st_insight', age:[10,80], w:4, cat:'cultivate', icon:'💡', title:'豁然贯通',
      text:() => '一段卡了三年的句子，今夜忽然通了。你丢下书冲出门外，对着月亮大笑出声。',
      fx:{ cult:32, intl:3, mood:9 } },
    { id:'st_boring', age:[8,80], w:3, cat:'school', icon:'😪', title:'读不进去',
      text:() => '书上的字一个一个都认识，连起来却进不了脑子。窗外的蝉叫得人心烦。',
      choices:[
        { t:'强撑着继续读', res:() => ({ out:'你掐着虎口硬读了两个时辰，记住的不过十之二三。', fx:{ intl:2, mood:-5, sta:-6 } }) },
        { t:'合上书出去走走', res:() => ({ out:'你在河边走了半日，回来时头脑清明——原来缺的不是勤奋，是一口气。', fx:{ mood:8, intl:-1, sta:6 } }) },
        { t:'换本闲书解闷', res:() => ({ out:'你翻起一本志怪。看着看着，竟从中悟出一点吐纳的道理。', fx:{ mood:5, intl:2, cult:5 } }) },
      ] },
  ],
  /* ---------- 运动 ---------- */
  train: [
    { id:'tr_beast', age:[10,80], w:5, cat:'battle', icon:'🐅', title:'山中遇虎',
      text:() => '晨跑的山道上，一头吊睛白额大虎拦在当间，尾巴一甩，低低地吼了一声。',
      choices:[
        { t:'拔剑相搏', sub:'胜负在天', res:() => (R() < 0.42 + s.sta * 0.003
            ? { out:'你侧身让过扑击，一剑刺入虎颈。虎血溅了你满脸，你喘着粗气，心跳得比任何时候都快。', fx:{ hp:-16, cult:26, mood:9, karma:2, sta:-10 }, _mark:'独力搏虎' }
            : { out:'你被虎爪拍飞出去，滚下山坡。若不是衣袍被树枝挂住，这条命就撂在这儿了。', fx:{ hp:-30, mood:-6, sta:-10 } }) },
        { t:'攀上古树避险', res:() => ({ out:'你在树上蹲了两个时辰，虎才悻悻离去。下来时腿软得几乎站不住。', fx:{ hp:-4, mood:-4, sta:-8 } }) },
        { t:'抛出干粮引它离开', res:() => ({ out:'你把怀里的干粮远远掷出去。虎嗅了嗅，叼着走了。你看着它消失，后背全是冷汗。', fx:{ hp:-2, money:-120, mood:3 } }) },
      ] },
    { id:'tr_waterfall', age:[10,80], w:4, cat:'cultivate', icon:'🌊', title:'瀑布淬体',
      text:() => '后山断崖垂下一道白练，潭水墨绿，寒气逼人。传说有人在此淬体，脱胎换骨。',
      choices:[
        { t:'纵身入潭', res:() => ({ out:'水柱砸在肩上像铁锤。你咬牙撑了一炷香，上岸时浑身通红，筋骨却像被重铸过。', fx:{ hp:-12, sta:14, cult:18, mood:5 } }) },
        { t:'只在潭边吐纳', res:() => ({ out:'你坐在潭边，借水气润养肺腑。虽无奇效，也算是没白来。', fx:{ sta:5, cult:6, mood:3 } }) },
      ] },
    { id:'tr_rival', age:[12,80], w:5, cat:'battle', icon:'🤺', title:'校场切磋',
      text:() => '校场上有人指名要与你切磋，围观者起哄。你握紧了拳。',
      choices:[
        { t:'全力以赴', res:() => (R() < 0.4 + s.sta * 0.002 + (s.talent === 'jianxin' ? 0.18 : 0)
            ? { out:'三招之内你逼得对方弃械。他拱手大笑：“好身手，我服了！”围观的人记住了你的名字。', fx:{ cha:5, mood:8, cult:12, sta:-8 } }
            : { out:'你被一记扫堂腿放倒，结结实实摔在黄土里。众人哄笑，你爬起来拍拍土，心里反倒亮堂了。', fx:{ hp:-10, mood:-4, intl:3, sta:-8 } }) },
        { t:'点到为止', res:() => ({ out:'你们拆了三十招，谁也没伤着谁。散场时他拍拍你的肩：“下次再战。”', fx:{ cha:3, mood:4, sta:-5 } }) },
        { t:'拱手认输', res:() => ({ out:'你笑了笑说“技不如人”。有人笑你窝囊，可你自己知道今天不必流血。', fx:{ cha:-2, mood:-2, karma:3, sta:4 } }) },
      ] },
    { id:'tr_qi', age:[8,80], w:4, cat:'cultivate', icon:'🌀', title:'经脉贯通',
      cond:() => s.rootKnown,
      text:() => '跑到第三十圈时，忽然一阵暖流自尾闾直冲泥丸。你停下脚步，知道自己打通了一处关窍。',
      fx:{ cult:36, sta:-6, mood:7, hp:4 }, _mark:'打通关窍' },
    { id:'tr_dawn', age:[8,90], w:3, cat:'festival', icon:'🌅', title:'晨遇老者',
      text:() => '天没亮，河堤上已有个老者在缓缓打拳。他的动作慢得像水在流。',
      choices:[
        { t:'跟着打一套', res:() => ({ out:'你跟着打了半个时辰，浑身微汗，通体舒泰。老者收势时看了你一眼：“年轻人，底子不错。”', fx:{ intl:3, hp:7, mood:6, sta:-5 } }) },
        { t:'上前请教拳理', res:() => ({ out:'老者只说了八个字：“以意领气，以气催力。”你琢磨了整宿，竟有所得。', fx:{ sta:9, cult:10, intl:2 } }) },
      ] },
    { id:'tr_horse', age:[14,70], w:3, cat:'treasure', icon:'🐎', title:'驯服灵驹',
      text:() => '荒原上有一匹无主的野马，通体墨黑，眼神桀骜。它冲你打了个响鼻。',
      choices:[
        { t:'翻身上去硬驯', res:() => ({ out:'你被甩下来三次，第四次终于稳稳骑住。它载着你狂奔十里，最后停下时，你们都喘着粗气。', fx:{ hp:-14, sta:11, mood:6, cha:3, money:600 }, _mark:'降服灵驹' }) },
        { t:'以灵草诱之', res:() => ({ out:'你花灵石买了捆灵草。它吃完，主动把头蹭进你怀里。', fx:{ money:-180, sta:8, mood:9, cha:4 } }) },
      ] },
    { id:'tr_sprain', age:[8,90], w:3, cat:'misfortune', icon:'🦶', title:'崴了脚',
      text:() => '一脚踏空，脚踝肿起老高。你坐在地上，哭笑不得。',
      fx:{ hp:-9, sta:-6, mood:-4 } },
  ],
  /* ---------- 休息 ---------- */
  rest: [
    { id:'re_dream', age:[8,90], w:4, cat:'cultivate', icon:'🌙', title:'梦中授道',
      cond:() => s.rootKnown,
      text:() => '你梦见自己站在一座空荡荡的大殿里，有个看不清面容的人对着你念了一段口诀，反复念了七遍。',
      choices:[
        { t:'醒来立刻默写下来', res:() => ({ out:'你披衣坐起，就着烛火把口诀一字不落地记下。此后参详，竟是一篇上乘心法。', fx:{ intl:5, cult:28, sta:-6 }, _mark:'得梦中授道' }) },
        { t:'翻身继续睡', res:() => ({ out:'你嘟囔一句“不过是梦”，扯过被子又睡了。这一觉睡得格外香。', fx:{ mood:7, sta:6 } }) },
      ] },
    { id:'re_family', age:[10,90], w:5, cat:'family', icon:'✉️', title:'家书抵万金',
      cond:() => s.parents.fa.alive || s.parents.mo.alive,
      text:() => '案上压着一封家书，字迹歪斜——是托人代写的。信里翻来覆去只有一句：什么时候回家。',
      choices:[
        { t:'回一封长长的平安信', res:() => ({ out:'你写了三页纸，把在外头的日子细细说了一遍。封口时，你才发现自己笑了很久。', fx:{ mood:8, karma:2 } }) },
        { t:'随信寄回一笔灵石', res:() => ({ out:'你在信里塞了灵石。半月后收到回信，母亲说：钱够花，你把自己照顾好。', fx:{ money:-320, mood:11, karma:4 } }) },
        { t:'搁在一旁，日后再说', res:() => ({ out:'你把信压回书底。此后每次看见它，心里都像被针扎了一下。', fx:{ mood:-4, karma:-2 } }) },
      ] },
    { id:'re_tea', age:[10,90], w:5, cat:'festival', icon:'🍵', title:'茶肆听书',
      text:() => '街角茶肆，说书人一拍醒木：“话说那剑仙一剑断岳——”满堂叫好。',
      choices:[
        { t:'叫壶好茶，听完全场', res:() => ({ out:'你听着听着，竟从那段故事里听出点剑理。散场时你还在咂摸。', fx:{ mood:9, intl:2, money:-30, cult:6 } }) },
        { t:'与邻座闲扯', res:() => ({ out:'邻座是个走南闯北的货郎，天南海北地聊了半天。你听得津津有味。', fx:{ cha:4, mood:6, intl:2 } }) },
        { t:'独坐窗边发呆', res:() => ({ out:'你什么也没做，就看了一下午的人来人往。回去时心里说不出的平静。', fx:{ mood:7, sta:7 } }) },
      ] },
    { id:'re_star', age:[10,90], w:4, cat:'cultivate', icon:'✨', title:'夜观星象',
      text:() => '今夜星河如练。你躺在屋顶上，看了很久。',
      choices:[
        { t:'试着推演自己的命数', res:() => ({ out:'你按星图排了自己的命盘。结果模糊不清，你却对前路多了几分把握。', fx:{ intl:5, cult:12, mood:-2, sta:-5 } }) },
        { t:'只是看看', res:() => ({ out:'你什么也没想，就那么躺着。夜风很凉，星星很亮。', fx:{ mood:8, sta:5 } }) },
      ] },
    { id:'re_pet', age:[8,90], w:3, cat:'treasure', icon:'🐱', title:'檐下小兽',
      text:() => '连着几日，有只瘸腿的小兽蹲在你檐下。你一开门，它就往后缩，却不肯走。',
      choices:[
        { t:'收养它', res:() => ({ out:'你买了灵药给它治腿。从此它天天趴在你修炼的蒲团边上打呼噜。', fx:{ money:-220, mood:11, cha:4 } }) },
        { t:'治好伤，放它走', res:() => ({ out:'你替它敷好药，把它送回山口。它回头看了你一眼，钻进了林子。', fx:{ mood:6, karma:4, money:-60 } }) },
        { t:'赶走它', res:() => ({ out:'你嫌它碍事，挥手赶了它。夜里听见屋外有低低的呜咽，你翻了个身。', fx:{ mood:-4, karma:-3 } }) },
      ] },
    { id:'re_ill', age:[8,90], w:3, cat:'misfortune', icon:'🤧', title:'受凉卧病',
      text:() => '贪凉睡了一夜，第二天就发起热来。你昏昏沉沉躺了三天。',
      fx:{ hp:-12, mood:-6, sta:9 } },
    { id:'re_sleepin', age:[8,90], w:3, cat:'festival', icon:'😴', title:'睡过头了',
      text:() => '本打算小憩片刻，睁眼时天已擦黑。你愣了半晌，索性又躺了回去。',
      fx:{ mood:9, sta:13, cult:-6 } },
  ],
  /* ---------- 修炼 ---------- */
  cultivate: [
    { id:'cu_bottleneck', age:[10,90], w:5, cat:'cultivate', icon:'🧱', title:'瓶颈当前',
      text:() => '修为卡在这一层已有半年，无论如何打坐，灵气都像撞在一堵软墙上。',
      choices:[
        { t:'强行冲关', res:() => ({ out:'你硬提灵气去撞那道关，结果气血逆行，喷出一口血来。关没冲开，人先伤了。', fx:{ hp:-16, cult:-22, mood:-5 } }) },
        { t:'下山游历散心', res:() => ({ out:'你收了功，去山下走了两个月。回来再坐时，那堵墙竟薄了一层。', fx:{ mood:9, cult:8, money:-120, sta:8 } }) },
        { t:'沉下心打磨根基', res:() => ({ out:'你不再求快，只把最粗浅的吐纳反复打磨。半年后某个清晨，那堵墙无声无息地塌了。', fx:{ cult:18, intl:4, sta:-9, mood:4 } }) },
      ] },
    { id:'cu_deviate', age:[10,90], w:3, cat:'misfortune', icon:'⚠️', title:'功法走偏',
      text:() => '入定中你忽然惊醒——灵气竟走岔了经脉。幸而发现得早，硬生生收了回来。',
      fx:{ hp:-11, cult:-26, mood:-5 } },
    { id:'cu_spirit', age:[10,90], w:3, cat:'treasure', icon:'💫', title:'灵气灌顶',
      cond:() => s.realm >= 1,
      text:() => '洞府灵脉忽然活跃，浓郁的灵气灌入百会。你不敢怠慢，盘膝坐了整整七日。',
      fx:{ cult:44, hp:-6, mood:9, sta:-8 } },
    { id:'cu_duo', age:[16,90], w:3, cat:'romance', icon:'💞', title:'双修共进',
      cond:() => s.lover && s.lover.married,
      text:() => `与${s.lover.name}并肩而坐，两股灵气在周天里交融往复。这一夜，比独自苦修十年更有所得。`,
      fx:{ cult:32, mood:9, sta:-6 } },
    { id:'cu_noise', age:[8,90], w:4, cat:'festival', icon:'🔊', title:'邻院喧哗',
      text:() => '隔壁院子搬来一户人家，整日敲敲打打，你入定三次被打断三次。',
      choices:[
        { t:'上门理论', res:() => ({ out:'你敲门说了几句，对方赔了不是，夜里果然安静了。只是邻里间，从此有了点隔阂。', fx:{ cha:-2, mood:4, cult:11 } }) },
        { t:'换个地方静修', res:() => ({ out:'你带着蒲团去了后山。路上耗了些工夫，倒是清静。', fx:{ sta:-7, cult:9, mood:2 } }) },
        { t:'随他去', res:() => ({ out:'你索性不练了，搬了个凳子坐在院里看他们忙活。看了半日，竟觉得挺有意思。', fx:{ cult:-8, mood:5, cha:2 } }) },
      ] },
  ],
  /* ---------- 打工 ---------- */
  work: [
    { id:'wo_boss', age:[14,80], w:5, cat:'sect', icon:'💼', title:'东家赏识',
      text:() => '东家今日亲自来柜台转了一圈，临走时意味深长地看了你一眼。',
      choices:[
        { t:'埋头苦干，拿出本事', res:() => ({ out:'你连着三日没怎么合眼，交出的活挑不出半点毛病。东家当场给你加了月钱。', fx:{ money:420, sta:-9, mood:4, cha:3 } }) },
        { t:'顺势上前讨赏', res:() => ({ out:'你笑着凑上去说了几句好话。东家一高兴，赏了些灵石，眼里却少了几分敬重。', fx:{ money:220, cha:2, karma:-1, mood:3 } }) },
        { t:'推说分内之事', res:() => ({ out:'你只说“这是该做的”。东家点点头走了，什么也没多说。过了几日，却有桩轻省差事落到了你头上。', fx:{ money:-120, mood:6, karma:4 } }) },
      ] },
    { id:'wo_cheat', age:[16,80], w:4, cat:'misfortune', icon:'🧮', title:'账上的窟窿',
      text:() => '你核对账目时发现，前任管事挪走了一笔数目不小的灵石。这事除了你，没人知道。',
      choices:[
        { t:'如实上报', res:() => ({ out:'你原原本本报了上去。东家震怒，追回大半，也赏了你一笔。只是那管事看你的眼神，从此带着刀。', fx:{ money:-120, karma:6, mood:2, cha:-2 } }) },
        { t:'闷声补上，据为己有', res:() => ({ out:'你按同样的手法做平了账，把那笔灵石揣进自己怀里。夜里你数了三遍，怎么也睡不着。', fx:{ money:460, karma:-9, mood:-3 } }) },
      ] },
    { id:'wo_injury', age:[14,80], w:3, cat:'misfortune', icon:'🩹', title:'工伤',
      text:() => '搬货时脚下打滑，一箱灵矿砸在小腿上。你咬着牙干完了这一天。',
      fx:{ hp:-14, money:170, mood:-5, sta:-8 } },
    { id:'wo_meet', age:[16,80], w:3, cat:'treasure', icon:'🎩', title:'柜台前的贵人',
      text:() => '一位气度不凡的客人来办差，随口问了句：“小友看着不像久居此地的人。”',
      choices:[
        { t:'直言自荐', res:() => ({ out:'你坦陈来路，也说了自己的志向。他听完，留下一枚玉简：“若有一日想换个活法，来找我。”', fx:{ cha:5, money:320, mood:5 } }) },
        { t:'安分做事，不多言', res:() => ({ out:'你只笑着把差事办妥。临走他多留了一块灵石，说“赏你的利落”。', fx:{ money:170, mood:3 } }) },
      ] },
    { id:'wo_theft', age:[14,80], w:3, cat:'misfortune', icon:'🥷', title:'库房遭窃',
      text:() => '半夜听见库房有响动。你提灯赶去，正撞见一个黑影翻窗而出。',
      choices:[
        { t:'追上去', res:() => (R() < 0.45 + s.sta * 0.002
            ? { out:'你追了三条街，把那贼按在地上。灵石追了回来，你也挂了彩。', fx:{ money:230, hp:-9, mood:7, cha:3 } }
            : { out:'你追出巷口就失去了目标。回来一看，库房被搬空了大半。', fx:{ money:-320, hp:-6, mood:-7 } }) },
        { t:'先保人要紧', res:() => ({ out:'你没有追，先把库房的门锁死、报了官。损失了一些，人没事。', fx:{ money:-220, mood:-4, karma:2 } }) },
      ] },
  ],
  /* ---------- 社交 ---------- */
  social: [
    { id:'so_drink', age:[16,80], w:5, cat:'festival', icon:'🍶', title:'席间拼酒',
      text:() => '有人端着海碗过来：“满饮此杯，方是朋友！”桌上七八双眼都看着你。',
      choices:[
        { t:'来者不拒', res:() => ({ out:'你连干了七八碗，最后伏在桌上笑得像个傻子。第二日头疼欲裂，同席的人却都记住了你。', fx:{ cha:5, hp:-11, mood:7 } }) },
        { t:'浅尝辄止', res:() => ({ out:'你举杯沾了沾唇，说了句软话挡了回去。没人怪你，也没人特别记得你。', fx:{ cha:2, mood:3 } }) },
        { t:'以茶代酒', res:() => ({ out:'你斟了碗清茶，说“茶能清心，酒能乱性，我陪诸位以茶尽兴”。满桌先是一静，继而叫好。', fx:{ cha:4, intl:2, mood:5, karma:2 } }) },
      ] },
    { id:'so_gossip', age:[12,80], w:5, cat:'festival', icon:'👂', title:'闲话是非',
      text:() => '茶余饭后，有人压低声音讲起某位同门的私事，讲得绘声绘色。',
      choices:[
        { t:'添油加醋接两句', res:() => ({ out:'你顺口补了几个细节，逗得众人哄笑。散场后你忽然想起：那人与你无冤无仇。', fx:{ cha:3, karma:-5, mood:4 } }) },
        { t:'替他说句话', res:() => ({ out:'你说了句“这事未必属实”。席上冷了半晌，有人讪讪转了话题。后来那位同门知道了，记在心里。', fx:{ cha:2, karma:6, mood:2 } }) },
        { t:'笑一笑，不接话', res:() => ({ out:'你只管喝茶。是非从耳边过，半点没沾身。', fx:{ mood:3, karma:1 } }) },
      ] },
    { id:'so_quarrel', age:[12,80], w:4, cat:'misfortune', icon:'😤', title:'当众口角',
      text:() => '一句话不对付，对方把酒盏顿在桌上，声音高了起来。',
      choices:[
        { t:'据理力争', res:() => ({ out:'你一条一条驳回去，说得他面红耳赤。理是你占了，气氛却僵到了冰点。', fx:{ cha:-3, mood:-5, intl:2, karma:-1 } }) },
        { t:'拱手致歉', res:() => ({ out:'你先低了头。他反倒不好意思，反过来敬了你一杯。', fx:{ cha:3, mood:-2, karma:3 } }) },
        { t:'拂袖而去', res:() => ({ out:'你一句话没说，起身就走。走出门才觉得胸口堵得慌。', fx:{ mood:-6, cha:-2 } }) },
      ] },
    { id:'so_gift', age:[14,80], w:4, cat:'romance', icon:'🎁', title:'备一份礼',
      cond:() => !!s.lover,
      text:() => `过些日子是${s.lover.name}的生辰。你在坊市转了三圈，还没拿定主意。`,
      choices:[
        { t:'买下那支贵得离谱的簪子', res:() => ({ out:'你咬牙买下。她接过时愣了很久，只说了句“你疯了”，眼睛却红了。', fx:{ money:-420, cha:6, mood:6 } }) },
        { t:'手书一封长信', res:() => ({ out:'你写了一夜，把说不出口的话都落在纸上。她看完，把信收进了怀里最贴身的地方。', fx:{ cha:4, intl:3, mood:8 } }) },
        { t:'什么也不送', res:() => ({ out:'你想了想，觉得来日方长。那天她等到了深夜。', fx:{ cha:-3, mood:-3 } }) },
      ] },
    { id:'so_reunion', age:[14,80], w:3, cat:'festival', icon:'🤝', title:'故友重逢',
      text:() => '街上有人拍你的肩。回头一看，是多年前走散的老友。你们在路边站了半个时辰。',
      fx:{ mood:9, cha:3, karma:1 } },
  ],
};
/* 各行为触发专属事件的概率 */
const ACTION_EVENT_RATE = { study:0.55, train:0.55, rest:0.55, cultivate:0.5, work:0.55, social:0.6 };
let actionEvent = null;
function rollActionEvent(actId) {
  const pool = (ACTION_EVENTS[actId] || []).filter(e =>
    !e.cond || (typeof e.cond === 'function' ? e.cond() : e.cond));
  if (!pool.length) return null;
  if (R() > (ACTION_EVENT_RATE[actId] || 0.5)) return null;
  return instantiate(weightedPick(pool, e => e.w * (e.wmul ? e.wmul() : 1)));
}

/* ---------------- 回合引擎 ---------------- */
function bumpParentsFav(st, d) {
  if (st.parents.fa.alive) st.parents.fa.fav = clamp(st.parents.fa.fav + d, 0, 100);
  if (st.parents.mo.alive) st.parents.mo.fav = clamp(st.parents.mo.fav + d, 0, 100);
}
function healParent(extra) {
  if (s.parents.fa.alive && s.parents.fa.age >= 66) s.parents.fa.age = Math.max(60, s.parents.fa.age - extra * 0.1);
  if (s.parents.mo.alive && s.parents.mo.age >= 66) s.parents.mo.age = Math.max(58, s.parents.mo.age - extra * 0.1);
}
function tickYear() {
  const o = ORIGINS[s.origin];
  let inc = SALARY[s.job] || 0;
  if (s.age <= 18) inc += o.allow || 0;
  const cost = 40 + s.children.length * 120 + (s.lover && s.lover.married ? 60 : 0);
  if (inc || cost) {
    s.money += inc - cost;
    log(`岁入 ${fmt(inc)} 灵石，用度 ${fmt(cost)} 灵石。`, 'sys');
  }
  if (s.origin === 'shijia' && s.age < 100) s.cult += 2;
  if (s.money < 0) { log(`负债${fmt(-s.money)}灵石，债主上门催逼，愁云惨淡。`, 'doom'); s.mood -= 3; }

  // 衰老
  const span = curSpan();
  if (s.age > span * 0.7) {
    const dmg = ((s.age - span * 0.7) / (span * 0.3)) * 16 * (s.talent === 'tiruo' ? 1.4 : 1);
    s.hp -= Math.max(0, dmg);
    if (s.hp < 30) log('年事已高，气血日渐衰败，你感到大限在逼近。', 'doom');
  }
  // 心境回归与关系滋养
  s.mood += (45 - s.mood) * 0.06;
  s.mood += Math.min(8, s.friends.length * 0.8);
  if (s.lover) s.mood += s.lover.married ? 2.5 : 1;
  s.mood += Math.min(6, s.children.length * 1.5);
  if (s.age > 45 && s.friends.length > 0 && R() < 0.05) { const f = s.friends.pop(); log(`故友${f}搬去了远方，从此音书渐稀。`, 'sys'); }
  // 父母
  for (const key of ['fa', 'mo']) {
    const p = s.parents[key];
    if (!p.alive) continue;
    p.age++;
    let dp = Math.max(0, (p.age - 72)) * 0.006 * (s.origin === 'pin' ? 1.5 : 1);
    if (p.age > 100) dp += 0.02;
    if (R() < dp) {
      p.alive = false;
      const who = key === 'fa' ? '父亲' : '母亲';
      mark(`${who}仙逝`);
      log(`${who}溘然长逝。你跪在灵前，想起此生种种，泪如雨下。`, 'doom');
      logChips(applyFx({ mood: p.fav >= 30 ? -15 : -8 }));
      if (s.origin !== 'pin' && s.age > 25) { log(`操办后事之余，家中留与你的产业折算${fmt(1500)}灵石。`, 'sys'); s.money += 1500; }
    } else if (p.age >= 66 && p.age % 7 === 0 && p.fav >= 55) {
      log(`${key === 'fa' ? '父亲' : '母亲'}健在，常念叨着你，盼你常回家看看。`, 'sys');
    }
  }
  // 三维枯竭的持续惩罚
  if (s.sta < DRAIN.sta) { s.hp -= 4; log('长年透支精力，身子骨一日不如一日。', 'doom'); }
  if (s.mood < DRAIN.mood) {
    const back = Math.max(3, s.cult * 0.03);
    s.cult = Math.max(0, s.cult - back);
    s.karma = clamp(s.karma - 1, -100, 100);
    log(`道心蒙尘，心魔日夜啃噬，修为退了${Math.round(back)}。`, 'doom');
  }
  if (s.hp < DRAIN.hp) { s.sta = clamp(s.sta - 6, 0, 100); s.mood -= 3; log('病骨支离，连抬手都费力气。', 'doom'); }
  s.hp = clamp(s.hp, 0, 100); s.mood = clamp(s.mood, 0, 100); s.sta = clamp(s.sta, 0, 100);
  checkDeath();
}
function checkDeath() {
  if (s.dead) return true;
  if (s.hp <= 0) { die(s.age >= curSpan() * 0.85 ? '油尽灯枯，坐化于静室' : '伤病缠身，药石无医'); return true; }
  if (s.hp < 5 && s.mood < 8 && R() < 0.3) { die('心死身灭，郁结而终'); return true; }
  if (s.hp < 5 && R() < 0.25) { die('油尽灯枯，形神俱灭'); return true; }
  if (s.age >= curSpan()) { die(s.realm >= 2 ? '寿元耗尽，含笑坐化' : '寿终正寝'); return true; }
  if (s.money <= -3000 && R() < 0.45) { die('负债累累，被债主追杀身亡'); return true; }
  return false;
}
function die(cause, win = false) {
  if (s.dead) return;
  s.dead = true; s.cause = cause; s.won = win;
  if (!win) { try { Music.fadeOut(); } catch (e) {} }
  mark(win ? cause : `卒 · ${cause}`);
  if (!win) showBanner('death', '一世终结', cause);
}
function buildQueue() {
  const q = [];
  const ms = MILESTONES.find(m => m.age === s.age && (!m.cond || m.cond()));
  if (ms) q.push(makeChoiceEvent(ms.id));
  const nr = nextRealm();
  if (nr && s.cult >= nr.need) q.push(makeBreakthrough(nr));
  if (s.realm === REALMS.length - 1 && s.cult >= ASCEND_NEED && !s.flags.refusedAscend) q.push(makeAscend());
  if (actionEvent) { q.push(actionEvent); actionEvent = null; }
  if (!s.dead) {
    const pool = EVENTS.filter(e => !e.at && (!e.age || (s.age >= e.age[0] && s.age <= e.age[1])) && (!e.cond || e.cond()));
    // 已有行为专属事件时，普通事件概率大幅降低，避免一年里塞两件事
    if (pool.length && R() < (ms ? 0.4 : (q.length ? 0.22 : 0.85))) {
      const ev = weightedPick(pool, e => e.w * (e.wmul ? e.wmul() : 1));
      q.push(instantiate(ev));
    }
  }
  return q;
}
function instantiate(ev) {
  if (ev.choices) return Object.assign({}, ev);
  const inst = Object.assign({}, ev);
  if (ev.roll) inst.result = ev.roll();
  return inst;
}
function makeChoiceEvent(id) {
  const base = CHOICE_EVENTS[id];
  return Object.assign({ id, choices: base.choices, title: base.title, cat: base.cat, icon: base.icon, text: base.text }, {});
}

let queue = [];
let evTextShown = '';
function doTurn(actionId) {
  if (phase !== 'action' || s.dead) return;
  const act = ACTIONS.find(a => a.id === actionId);
  if (!act || (act.show && !act.show())) return;
  s.turn++;
  logYear();
  applyAction(actionId);
  actionEvent = s.dead ? null : rollActionEvent(actionId);
  if (checkDeath()) { finishTurn(); return; }
  s.age++;
  tickYear();
  if (s.dead) { finishTurn(); return; }
  queue = buildQueue();
  processQueue();
}
function processQueue() {
  renderPanel();
  if (s.dead) { finishTurn(); return; }
  if (!queue.length) { finishTurn(); return; }
  presentEvent(queue.shift());
}
function finishTurn() {
  phase = 'action';
  if (s.dead) { saveGame(); showEnding(); return; }
  if (!queue.length) log(pick(CALM_LINES), 'sys');
  renderPanel(); renderActions();
  saveGame();
}

/* ---------------- 事件呈现 ---------------- */
function presentEvent(ev) {
  phase = 'event';
  current = ev;
  $('actions').innerHTML = '';
  const card = $('event-card');
  card.classList.remove('hidden');
  const img = $('ev-img');
  img.classList.remove('duo', 'cg-mode');
  const cgKey = CG_LIB[ev.id] ? ev.id : (ev.enc != null ? 'enc' + ev.enc : null);
  const cgGirl = cgKey ? cgGirlFor(ev) : null;
  if (cgKey && cgGirl) {
    img.classList.add('cg-mode');
    renderCG(img, cgKey, cgGirl);
  } else if (ev.cat === 'romance' && s.lover) {
    img.classList.add('duo');
    img.innerHTML = portraitSVG(s).svg + `<span class="duo-heart">❤</span>` + (s.gender === 'm' ? portraitF(s.lover.aura || '#f0a0c8', s.lover.pic != null ? s.lover.pic : 0) : portraitM(s.lover.aura || '#8fb8f0', s.lover.look || 0));
  } else if (ev.enc != null) {
    const w = encWho(ev.enc);
    img.innerHTML = s.gender === 'm' ? portraitF(w.aura, w.pic) : portraitM(w.aura, w.look || 0);
  } else {
    img.innerHTML = `<div class="scene">${sceneSVG(ev.cat)}</div><div class="ev-emoji">${ev.icon || '✨'}</div>`;
  }
  $('ev-cat').textContent = CAT_NAME[ev.cat] || '世事';
  $('ev-title').textContent = ev.title;
  evTextShown = typeof ev.text === 'function' ? ev.text() : (ev.text || '');
  $('ev-text').innerHTML = evTextShown;
  $('ev-text').style.display = evTextShown ? '' : 'none';
  const ch = $('ev-choices'); ch.innerHTML = '';
  $('ev-out').classList.add('hidden');
  $('ev-continue').classList.add('hidden');
  if (ev.choices) {
    visibleChoices = ev.choices.filter(c => !c.show || c.show());
    /* 极端兜底：所有选项都被条件过滤掉时，按“作罢”处理，避免事件卡死 */
    if (!visibleChoices.length) {
      visibleChoices = [];
      showOutcome({ out: '思来想去，时机未至，只得作罢。', fx: {} });
      return;
    }
    visibleChoices.forEach((c, i) => {
      const b = document.createElement('button');
      b.className = 'choice-btn';
      b.innerHTML = `${'甲乙丙丁戊'[i] || '•'} · ${c.t}${c.sub ? `<span class="sub">${c.sub}</span>` : ''}`;
      b.onclick = () => resolveChoice(i);
      ch.appendChild(b);
    });
  } else {
    const fx = typeof ev.fx === 'function' ? ev.fx() : ev.fx;
    const res = ev.result || { out: evTextShown, fx, side: ev.side };
    showOutcome(res);
  }
}
function resolveChoice(i) {
  const c = visibleChoices[i];
  if (!c) return;
  const r = c.res ? c.res() : { fx: c.fx, out: c.out };
  showOutcome(r);
}
function showOutcome(r) {
  $('ev-choices').innerHTML = '';
  let chips = [];
  if (r.fx) chips = applyFx(r.fx);
  if (r._side) r._side(s);
  if (r.side) r.side();
  if (r._mark) mark(r._mark);
  if (r._banner) showBanner(...r._banner);
  const out = $('ev-out');
  out.classList.remove('hidden');
  const showOut = r.out && r.out !== evTextShown;
  out.innerHTML = `${showOut ? `<div class="o-text">${r.out}</div>` : ''}<div class="chips">${chips.map(c => `<span class="chip ${c.v > 0 ? 'up' : 'dn'}">${FX_LABEL[c.k]} ${c.v > 0 ? '+' : ''}${fmt(c.v)}</span>`).join('')}</div>`;
  const cont = $('ev-continue');
  cont.classList.remove('hidden');
  cont.innerHTML = '';
  const b = document.createElement('button');
  b.className = 'btn primary serif';
  b.textContent = s.dead ? '踏入轮回' : '继 续';
  b.onclick = advanceEvent;
  cont.appendChild(b);
  log(`◈ <b>${current.title}</b> · ${(r.out || '').replace(/<[^>]+>/g, '')}`, 'ev');
  logChips(chips);
  checkDeath();
  renderPanel();
}
function advanceEvent() {
  $('event-card').classList.add('hidden');
  current = null;
  if (s.dead) { finishTurn(); return; }
  processQueue();
}

/* ---------------- 渲染 ---------------- */
const REALM_COLOR = ['#8a93b8','#9fd7ff','#7fe0ff','#ffd97a','#c9a2ff','#ff9aa8','#ffb36b','#fff3b0'];
function renderPanel() {
  const p = $('panel');
  const { svg } = portraitSVG(s);
  const span = curSpan();
  const nr = nextRealm();
  const pcls = s.age < 13 ? 'p-child' : (s.age > span * 0.72 ? 'p-old' : '');
  const rootTag = s.rootKnown ? `<span class="tag jade">灵根·${ROOTS[s.root].name}</span>` : `<span class="tag">灵根·未觉醒</span>`;
  const loverLine = s.lover
    ? `<div class="rel-line"><b>${s.lover.married ? '道侣' : '心上人'} · ${s.lover.name}</b><span>${s.lover.desc ? s.lover.desc + ' · ' : ''}好感 ${s.lover.fav}</span></div>`
    : `<div class="rel-line"><b>未有良缘</b><span class="dead">——</span></div>`;
  const kids = s.children.length ? s.children.map(c => c.name).join('、') : '——';
  const parLine = k => {
    const p = s.parents[k];
    return p.alive ? `<span>${k === 'fa' ? '父' : '母'} ${p.fav}</span>` : `<span class="dead">${k === 'fa' ? '父' : '母'} 仙逝</span>`;
  };
  const bar = (lb, vl, c, width, tip) => `<div class="stat-row" ${tip ? `title="${tip}"` : ''}><span class="lb">${lb}</span><div class="bar" style="--c:${c}"><i style="width:${width}%"></i></div><span class="vl">${vl}</span></div>`;
  p.innerHTML = `
    <div id="portrait-box" class="${pcls}">${svg}</div>
    <div class="ch-name"><b>${s.name}</b><span>${s.gender === 'm' ? '♂ 男修' : '♀ 女修'} · ${s.age}岁</span></div>
    <div class="tag-row">
      <span class="tag">${ORIGINS[s.origin].name}</span>
      <span class="tag">${TALENTS[s.talent].name}</span>
      ${rootTag}
      ${s.job ? `<span class="tag purple">${s.job}</span>` : ''}
    </div>
    <div class="realm-badge serif" style="color:${REALM_COLOR[s.realm]};border-color:rgba(255,255,255,.18);text-shadow:0 0 14px ${REALM_COLOR[s.realm]}">${REALMS[s.realm].name}</div>
    ${nr ? `<div class="cult-row"><span>修为 ${Math.floor(s.cult)}</span><span>突破${nr.name}需 ${nr.need}</span></div>
    <div class="bar" style="--c:linear-gradient(90deg,#57d3ae,#a8f0ff)"><i style="width:${clamp(s.cult / nr.need * 100, 0, 100)}%"></i></div>`
      : `<div class="cult-row"><span>修为 ${Math.floor(s.cult)}</span><span style="color:var(--gold2)">圆满</span></div>`}
    <div class="cult-row"><span>寿元</span><span>约 ${span} 载</span></div>
    ${bar('❤️ 气血', Math.round(s.hp), 'linear-gradient(90deg,#57d3ae,#8ef0c8)', s.hp, '气血（健康）：归零则身死。低于20病危，走火入魔风险大增；气血充盈亦有助于突破')}
    ${bar('🪷 道心', Math.round(s.mood), 'linear-gradient(90deg,#ef8fb0,#ffc0d8)', s.mood, '道心（心情）：低于15生心魔，修行社交迟滞、修为逐年倒退。挥霍与休息可补')}
    ${bar('⚡ 精力', Math.round(s.sta), 'linear-gradient(90deg,#ffb36b,#ffd9a8)', s.sta, '精力（体力）：低于15力竭，修炼／学习／打工收益减半。运动与休息可补')}
    ${drainWarnHtml()}
    <div class="mini-grid" title="悟性：影响学习所得与诸多事件判定｜魅力：影响邂逅结缘与社交收益｜灵性：影响修炼速度与突破成功率">
      <span class="k">📖 悟性</span><span class="v">${Math.round(s.intl)}</span>
      <span class="k">🌸 魅力</span><span class="v">${Math.round(s.cha)}</span>
      <span class="k">✨ 灵性</span><span class="v">${Math.round(s.gift)}</span>
      <span class="k">💰 灵石</span><span class="v ${s.money < 0 ? 'neg' : ''}">${fmt(s.money)}</span>
      <span class="k">⚖️ 善恶</span><span class="v">${s.karma > 20 ? '善' : s.karma < -20 ? '恶' : '中庸'} (${s.karma > 0 ? '+' : ''}${Math.round(s.karma)})</span>
    </div>
    <div class="karma-wrap"><div>正气 ←→ 魔念</div><div class="karma-bar"><i style="left:${(s.karma + 100) / 2}%"></i></div></div>
    <div class="rel-box">
      <div class="rt serif">人 间 牵 挂</div>
      <div class="rel-line"><b>高堂</b>${parLine('fa')} ${parLine('mo')}</div>
      <div class="rel-line"><b>挚友</b><span>${s.friends.length ? `${s.friends.length}人` : '——'}</span></div>
      ${loverLine}
      <div class="rel-line"><b>儿女</b><span>${kids}</span></div>
    </div>`;
  $('hd-age').innerHTML = `${s.name} · <b>${s.age}</b> 岁 · ${REALMS[s.realm].name} · 第 <b>${s.turn}</b> 年`;
}
function renderActions() {
  const box = $('actions');
  const locked = phase !== 'action' || autoPlaying || s.dead;
  box.innerHTML = `<div class="act-grid">${ACTIONS.filter(a => !a.show || a.show()).map(a =>
    `<button class="act-btn" data-act="${a.id}" ${locked ? 'disabled' : ''}>
      <span class="ic">${a.ic}</span><span class="nm serif">${a.name}</span><span class="tip">${a.tip}</span>
    </button>`).join('')}</div>
    <div class="act-hint">${locked ? (autoPlaying ? '岁月如梭中……' : '命运正在展开……') : (drainWarns().length ? `⚠ ${drainWarns().join('、')} —— 该【休息】了` : '一年将逝，且做一件大事')}</div>`;
  box.querySelectorAll('.act-btn').forEach(b => b.onclick = () => doTurn(b.dataset.act));
}

/* ---------------- 结局 ---------------- */
function endingTitle() {
  if (s.won) return '飞升上界 · 逍遥仙';
  if (s.realm >= 6) return '天劫之中 · 一界至尊';
  if (s.realm >= 5) return s.karma <= -40 ? '魔道巨擘' : '化神真君';
  if (s.realm >= 4) return '一派老祖';
  if (s.realm >= 3) return s.karma <= -40 ? '魔道枭雄' : '一代宗师';
  if (s.money >= 30000) return '灵石堆山 · 富甲一方';
  if (s.intl >= 85) return '惊世大儒';
  if (s.lover && s.lover.married && s.children.length >= 2 && s.mood >= 60) return '幸福道侣';
  if (!s.lover && s.friends.length === 0) return '孤家寡人';
  if (s.money < 0) return '负债潦倒 · 一世清贫';
  if (s.mood < 35) return '郁郁一生 · 抱憾而终';
  return '平凡一生 · 红尘过客';
}
function endingScore() {
  let sc = s.realm * 120;
  sc += Math.min(300, Math.max(0, Math.log10(Math.max(1, s.money + 3000))) * 60);
  sc += s.intl * 2 + s.cha * 1.5 + Math.round(s.mood) * 1.5 + Math.round(s.hp);
  sc += s.friends.length * 15 + (s.lover ? (s.lover.married ? 120 : 50) : 0) + s.children.length * 30;
  sc += s.karma * 0.8 + s.milestones.length * 8 + Math.floor(s.cult / 50);
  if (s.won) sc += 2000;
  return Math.round(sc);
}
function endingPoem() {
  const l = [];
  l.push(`生于${ORIGINS[s.origin].name}，身负${TALENTS[s.talent].name}，${s.rootKnown ? `${ROOTS[s.root].name}加身` : '灵根未启，一世凡尘'}。`);
  l.push(`一生修至<b>${REALMS[s.realm].name}${s.won ? '，白日飞升' : ''}</b>，坐拥灵石${fmt(s.money)}。`);
  l.push(s.lover ? `${s.lover.married ? `与道侣${s.lover.name}结发同修` : `与${s.lover.name}相知相恋`}${s.children.length ? `，膝下${s.children.length}个儿女` : ''}。` : (s.friends.length ? `无风月之事，有${s.friends.length}位知己同行。` : '无风月，无知己，独行于世。'));
  if (s.karma >= 40) l.push('一世行善，福泽绵长。');
  if (s.karma <= -40) l.push('魔念深种，冤孽随身。');
  return l.join('<br>');
}
function showEnding() {
  phase = 'end';
  $('scr-game').classList.add('hidden');
  $('event-card').classList.add('hidden');
  $('scr-end').classList.remove('hidden');
  const { svg, aura } = portraitSVG(s);
  const halo = s.won || s.realm >= 4;
  $('end-title').textContent = endingTitle();
  $('end-score').innerHTML = `终年 <b>${s.age}</b> 岁 · 综合评定 <b>${endingScore()}</b> · ${s.won ? '此生圆满' : s.cause}`;
  const ep = $('end-portrait');
  ep.innerHTML = svg;
  const epsvg = ep.firstElementChild;
  epsvg.classList.add('halo');
  if (!halo) epsvg.classList.add('dark');
  $('end-poem').innerHTML = endingPoem();
  const stats = [
    ['境界', REALMS[s.realm].name], ['终年', s.age + '岁'],
    ['灵石', fmt(s.money)], ['修为', Math.floor(s.cult)],
    ['悟性', Math.round(s.intl)], ['魅力', Math.round(s.cha)],
    ['结局', s.won ? '白日飞升' : '含笑而逝'], ['善恶', s.karma > 0 ? '+' + Math.round(s.karma) : Math.round(s.karma)],
  ];
  $('end-stats').innerHTML = stats.map(x => `<div class="es-cell"><div class="k">${x[0]}</div><div class="v">${x[1]}</div></div>`).join('');
  $('end-ms').innerHTML = `<b>一生大事记</b><br>` + s.milestones.map(m => `· ${m}`).join('<br>');
  localStorage.removeItem(SAVE_KEY);
}

/* ---------------- 存档 ---------------- */
function saveGame() {
  if (!s || s.dead) return;
  try { localStorage.setItem(SAVE_KEY, JSON.stringify(s)); }
  catch (e) { try { memorySave = JSON.stringify(s); } catch (e2) {} }
}
/* localStorage 在部分平板的 file:// 下会被禁用，用内存兜底，保证本局内可读档 */
let memorySave = null;
function loadGame() {
  try {
    const raw = localStorage.getItem(SAVE_KEY) || memorySave;
    if (!raw) return null;
    const d = JSON.parse(raw);
    if (!d || !d.name) return null;
    return d;
  } catch (e) { return null; }
}

/* ---------------- 岁月如梭 ---------------- */
function autoAction() {
  if (s.age < 7) return 'rest';
  if (s.age < 19) return s.hp < 35 ? 'rest' : 'study';
  if (s.money < -300) return 'work';
  if (s.hp < 28) return 'rest';
  if (s.mood < 25) return 'rest';
  if (s.rootKnown) return 'cultivate';
  if (s.age >= 14 && s.money < 400) return 'work';
  return R() < 0.5 ? 'social' : 'train';
}
async function fastForward() {
  if (autoPlaying || s.dead || phase !== 'action') return;
  autoPlaying = true; renderActions();
  for (let i = 0; i < 16 && !s.dead; i++) {
    if (phase === 'action') {
      await sleep(360);
      if (phase !== 'action') continue;
      let act = autoAction();
      const acts = ACTIONS.filter(a => (!a.show || a.show()));
      if (!acts.find(a => a.id === act)) act = 'rest';
      doTurn(act);
    } else if (phase === 'event' && current) {
      await sleep(430);
      /* 先点「继续」推进，避免对同一抉择事件重复结算 */
      const cont = $('ev-continue');
      if (cont && !cont.classList.contains('hidden')) { advanceEvent(); continue; }
      if (current.choices && visibleChoices.length) { resolveChoice(ri(0, visibleChoices.length - 1)); continue; }
      break;
    } else break;
    if (phase === 'end') break;
  }
  autoPlaying = false;
  if (!s.dead) renderActions();
}

/* ---------------- 开局 ---------------- */
let startGender = 'm';
let startLook = 0;
function renderPreview() {
  startLook = ri(0, MALE_LOOKS.length - 1);
  $('preview-portrait').innerHTML = startGender === 'm' ? portraitM('#8fb8f0', startLook) : portraitF('#f0a0c8', (R()*3)|0);
  const lookNote = startGender === 'm' ? `此世容颜 ·「${MALE_LOOKS[startLook].name}」<br>` : '';
  $('lead-note').innerHTML = `${lookNote}情缘不设预选——七位风姿各异的女子，将在人生旅途的不同际遇中陆续登场。`;
}
function descLine() {
  const o = $('in-origin').value, t = $('in-talent').value;
  let txt = '';
  if (o !== 'rand') txt += `【出身 · 耗${ORIGIN_COST[o]}点】${ORIGINS[o].desc}<br>`;
  else txt += '【出身 · 随机】随机天命不耗点，但一切交给命运<br>';
  if (t !== 'rand') txt += `【天赋 · 耗${TALENT_COST[t]}点】${TALENTS[t].desc}`;
  else txt += '【天赋 · 随机】随机天命不耗点，好赖全凭气运';
  $('desc-line').innerHTML = txt;
}
let buildKey = 'jian';
function applyBuild(key) {
  if (!BUILDS[key]) key = 'jian';
  buildKey = key;
  const b = BUILDS[key];
  alloc = { sta: 0, intl: 0, cha: 0, gift: 0 };
  let n = Math.max(0, allocLeft());
  if (b.w) {
    /* 最大余数法：按流派权重比例分配，尊重单项上限 */
    const keys = Object.keys(b.w), total = keys.reduce((s, k) => s + b.w[k], 0);
    let used = 0;
    keys.forEach(k => { alloc[k] = Math.min(ALLOC_CAP[k], Math.floor(n * b.w[k] / total)); used += alloc[k]; });
    const order = keys.slice().sort((a, c) => b.w[c] - b.w[a]);
    let rem = n - used, guard = 99;
    while (rem > 0 && guard--) {
      let moved = false;
      for (const k of order) if (rem > 0 && alloc[k] < ALLOC_CAP[k]) { alloc[k]++; rem--; moved = true; }
      if (!moved) break;
    }
  } else {
    /* 天命随机：全凭气运 */
    const keys = Object.keys(ALLOC_LABEL);
    let guard = 999;
    while (n > 0 && guard--) {
      const k = pick(keys);
      if (alloc[k] < ALLOC_CAP[k]) { alloc[k]++; n--; }
      else if (keys.every(x => alloc[x] >= ALLOC_CAP[x])) break;
    }
  }
  renderBuild();
}
function renderBuild() {
  const row = $('build-row');
  if (!row) return;
  row.querySelectorAll('.build-btn').forEach(btn => btn.classList.toggle('on', btn.dataset.b === buildKey));
  const b = BUILDS[buildKey];
  const stats = Object.keys(ALLOC_LABEL).map(k => `${ALLOC_LABEL[k]} <b>${ALLOC_BASE[k] + alloc[k]}</b>`).join(' · ');
  $('stat-preview').innerHTML = `【${b.name}】${stats}<span class="b-tip">${b.tip}</span>`;
}
function randomizeStart() {
  $('in-name').value = randName();
  renderPreview();
  const o = pick(['shijia', 'tong', 'pin']);
  const t = pick(Object.keys(TALENTS));
  $('in-origin').value = o; $('in-talent').value = t;
  applyBuild(pick(Object.keys(BUILDS)));
  descLine();
}
function startGame() {
  if (allocLeft() < 0) {
    applyBuild(buildKey);
    return;
  }
  const name = $('in-name').value.trim() || randName();
  const origin = $('in-origin').value === 'rand' ? pick(['shijia', 'tong', 'pin']) : $('in-origin').value;
  const talent = $('in-talent').value === 'rand' ? pick(Object.keys(TALENTS)) : $('in-talent').value;
  s = newState({ name, gender: startGender, origin, talent, alloc: { ...alloc }, look: startLook });
  try { Music.unlock(); Music.resume(); } catch (e) {}
  $('scr-start').classList.add('hidden');
  $('scr-end').classList.add('hidden');
  $('scr-game').classList.remove('hidden');
  $('log').innerHTML = '';
  phase = 'action'; queue = []; current = null;
  log(`你叫<b>${s.name}</b>，降生于${ORIGINS[s.origin].name}。命运的卷轴，就此展开。`, 'big');
  renderPanel(); renderActions();
  saveGame();
}


/* ---------------- 背景音乐（Web Audio 程序化生成·田园序曲风） ----------------
 * 参考《星露谷物语》序曲的音乐特征重新作曲（原创旋律，避免版权音频）：
 * · B 大调，约 90 BPM，4/4 —— 温暖、怀旧、田园感
 * · 钢片琴/钟琴质地的主旋律 + 弦乐铺底 + 柔和低音（低频厚、高频点缀）
 * · 每 4 小节一次强弱起伏，复刻原曲的能量涨落轮廓
 * · 结构：A 段（轻）→ A' 段（加厚）→ B 段（全奏 + 竖琴琶音）循环
 */
const Music = (function () {
  let ctx = null, master = null, delay = null, timer = null;
  let on = true, vol = 0.32, running = false;
  let nextTime = 0, step = 0, cycle = 0;

  const BPM = 90, STEP = 60 / BPM / 2;        // 八分音符时长
  const mtof = m => 440 * Math.pow(2, (m - 69) / 12);
  const CYCLE_STEPS = 128;                    // 16 小节 × 8 步

  /* B 大调音级 → 半音（相对 B4=71）：B C# D# E F# G# A# */
  const SCALE = [0, 2, 4, 5, 7, 9, 11];
  const deg = (n, oct = 0) => 71 + SCALE[(n - 1) % 7] + 12 * (oct + Math.floor((n - 1) / 7));

  /* 16 小节和声进行：I vi IV V ×2，随后 IV I vi V / IV I vi V */
  const CHORDS = [
    { r: 1, m: 0 }, { r: 6, m: 1 }, { r: 4, m: 0 }, { r: 5, m: 0 },
    { r: 1, m: 0 }, { r: 6, m: 1 }, { r: 4, m: 0 }, { r: 5, m: 0 },
    { r: 4, m: 0 }, { r: 1, m: 0 }, { r: 6, m: 1 }, { r: 5, m: 0 },
    { r: 4, m: 0 }, { r: 1, m: 0 }, { r: 6, m: 1 }, { r: 5, m: 0 },
  ];
  function chordTones(c) {                    // 中音区铺底和弦音（B3 一带）
    const root = deg(c.r, 0) - 12;
    return [root, root + (c.m ? 3 : 4), root + 7, root + 12];
  }

  /* 旋律：{d: midi 或 -1 休止, len: 八分音符数}。A(4小节) + A'(4小节) + B(8小节) */
  const PH_A = [
    { d: 78, len: 2 }, { d: 75, len: 2 }, { d: 71, len: 4 },
    { d: -1, len: 2 }, { d: 71, len: 2 }, { d: 73, len: 2 }, { d: 75, len: 2 },
    { d: 76, len: 2 }, { d: 75, len: 2 }, { d: 71, len: 2 }, { d: 68, len: 2 },
    { d: 70, len: 2 }, { d: 71, len: 6 },
  ];
  const PH_A2 = [
    { d: 78, len: 2 }, { d: 75, len: 2 }, { d: 71, len: 4 },
    { d: -1, len: 2 }, { d: 71, len: 2 }, { d: 73, len: 2 }, { d: 75, len: 2 },
    { d: 80, len: 2 }, { d: 78, len: 2 }, { d: 76, len: 2 }, { d: 75, len: 2 },
    { d: 76, len: 2 }, { d: 73, len: 2 }, { d: 70, len: 4 },
  ];
  const PH_B = [
    { d: 76, len: 2 }, { d: 80, len: 2 }, { d: 83, len: 4 },
    { d: 82, len: 2 }, { d: 78, len: 2 }, { d: 75, len: 4 },
    { d: 80, len: 2 }, { d: 78, len: 2 }, { d: 75, len: 2 }, { d: 71, len: 2 },
    { d: 73, len: 2 }, { d: 75, len: 2 }, { d: 78, len: 4 },
    { d: 76, len: 2 }, { d: 80, len: 2 }, { d: 83, len: 2 }, { d: 82, len: 2 },
    { d: 83, len: 4 }, { d: 78, len: 4 },
    { d: 76, len: 2 }, { d: 75, len: 2 }, { d: 73, len: 2 }, { d: 71, len: 2 },
    { d: 70, len: 2 }, { d: 73, len: 2 }, { d: 78, len: 4 },
  ];
  /* 预展开：一个循环内每个八分步对应的旋律事件 */
  const EV = new Array(CYCLE_STEPS).fill(null);
  (function () {
    let at = 0;
    for (const e of PH_A.concat(PH_A2, PH_B)) {
      if (e.d >= 0) EV[at] = e;
      at += e.len;
    }
  })();

  const SWELL = [0.72, 0.88, 1.0, 0.8];       // 每 4 小节的强弱起伏

  function build() {
    if (ctx) return true;
    try {
      const AC = window.AudioContext || window.webkitAudioContext;
      if (!AC) return false;
      ctx = new AC();
      master = ctx.createGain(); master.gain.value = on ? vol : 0;
      master.connect(ctx.destination);
      // 柔和空间感：短延迟 + 低通阻尼
      delay = ctx.createDelay(1.0); delay.delayTime.value = 0.33;  // 与 90BPM 拍点同步
      const fb = ctx.createGain(); fb.gain.value = 0.3;
      const damp = ctx.createBiquadFilter(); damp.type = 'lowpass'; damp.frequency.value = 2600;
      delay.connect(damp); damp.connect(fb); fb.connect(delay); delay.connect(master);
      return true;
    } catch (e) { ctx = null; return false; }
  }
  /* 钢片琴/钟琴质地的主音：正弦基音 + 非谐泛音 + 八度三角波 */
  function bell(t, midi, dur, vel) {
    const f = ctx.createBiquadFilter(); f.type = 'lowpass'; f.frequency.value = 5200; f.Q.value = 0.5;
    const g = ctx.createGain();
    g.gain.setValueAtTime(0.0001, t);
    g.gain.linearRampToValueAtTime(vel, t + 0.006);
    g.gain.exponentialRampToValueAtTime(0.0001, t + Math.max(dur, 0.4) + 0.7);
    const o = ctx.createOscillator(); o.type = 'sine'; o.frequency.value = mtof(midi);
    const o2 = ctx.createOscillator(); o2.type = 'sine'; o2.frequency.value = mtof(midi) * 2.756;
    const g2 = ctx.createGain();
    g2.gain.setValueAtTime(0.0001, t);
    g2.gain.linearRampToValueAtTime(vel * 0.16, t + 0.004);
    g2.gain.exponentialRampToValueAtTime(0.0001, t + dur * 0.5 + 0.1);
    const o3 = ctx.createOscillator(); o3.type = 'triangle'; o3.frequency.value = mtof(midi + 12);
    const g3 = ctx.createGain();
    g3.gain.setValueAtTime(0.0001, t);
    g3.gain.linearRampToValueAtTime(vel * 0.14, t + 0.008);
    g3.gain.exponentialRampToValueAtTime(0.0001, t + dur * 0.7 + 0.3);
    o.connect(f); f.connect(g); g.connect(master); g.connect(delay);
    o2.connect(g2); g2.connect(master);
    o3.connect(g3); g3.connect(master);
    o.start(t); o2.start(t); o3.start(t);
    o.stop(t + dur + 1.0); o2.stop(t + dur + 0.6); o3.stop(t + dur + 0.8);
  }
  /* 弦乐铺底：锯齿波 + 缓慢起音 + 低通，双振荡器轻微失谐 */
  function pad(t, midi, dur, vel) {
    const f = ctx.createBiquadFilter(); f.type = 'lowpass'; f.frequency.value = 1000; f.Q.value = 0.4;
    const g = ctx.createGain();
    g.gain.setValueAtTime(0.0001, t);
    g.gain.linearRampToValueAtTime(vel, t + 0.55);
    g.gain.setValueAtTime(vel, t + dur * 0.7);
    g.gain.exponentialRampToValueAtTime(0.0001, t + dur + 0.5);
    [-6, 6].forEach(cents => {
      const o = ctx.createOscillator(); o.type = 'sawtooth';
      o.frequency.value = mtof(midi) * Math.pow(2, cents / 1200);
      o.connect(f); o.start(t); o.stop(t + dur + 0.6);
    });
    f.connect(g); g.connect(master);
  }
  /* 低音：柔和三角波，落在 1、3 拍 */
  function bass(t, midi, dur) {
    const o = ctx.createOscillator(); o.type = 'triangle'; o.frequency.value = mtof(midi);
    const f = ctx.createBiquadFilter(); f.type = 'lowpass'; f.frequency.value = 620;
    const g = ctx.createGain();
    g.gain.setValueAtTime(0.0001, t);
    g.gain.linearRampToValueAtTime(0.085, t + 0.03);
    g.gain.exponentialRampToValueAtTime(0.0001, t + dur);
    o.connect(f); f.connect(g); g.connect(master);
    o.start(t); o.stop(t + dur + 0.1);
  }
  /* 竖琴琶音音色：轻、亮、短 */
  function harp(t, midi, vel) {
    const o = ctx.createOscillator(); o.type = 'sine'; o.frequency.value = mtof(midi);
    const g = ctx.createGain();
    g.gain.setValueAtTime(0.0001, t);
    g.gain.linearRampToValueAtTime(vel, t + 0.005);
    g.gain.exponentialRampToValueAtTime(0.0001, t + 0.5);
    o.connect(g); g.connect(master); g.connect(delay);
    o.start(t); o.stop(t + 0.6);
  }
  /* 极轻打击：仅 B 段提供律动 */
  function tick(t, vel) {
    const o = ctx.createOscillator(); o.type = 'sine'; o.frequency.value = 950;
    const g = ctx.createGain();
    g.gain.setValueAtTime(0.0001, t);
    g.gain.linearRampToValueAtTime(vel, t + 0.003);
    g.gain.exponentialRampToValueAtTime(0.0001, t + 0.07);
    o.connect(g); g.connect(master);
    o.start(t); o.stop(t + 0.09);
  }
  function schedule() {
    if (!ctx || !running) return;
    const now = ctx.currentTime;
    while (nextTime < now + 1.5) {
      const sc = step % CYCLE_STEPS;          // 循环内步
      const bc = (sc / 8) | 0;                // 循环内小节
      const intro = cycle === 0 && bc < 4;    // 首循环前 4 小节：安静引子
      const swell = SWELL[bc % 4] * (intro ? 0.55 : 1);
      const c = CHORDS[bc];
      const tones = chordTones(c);
      if (sc % 8 === 0) {                     // 小节头：铺底 + 低音根音
        tones.forEach(m => pad(nextTime, m, 8 * STEP, 0.017 * swell));
        bass(nextTime, deg(c.r, -2), STEP * 3.4);
      } else if (sc % 8 === 4) {              // 3 拍：低音五度
        bass(nextTime, deg(c.r, -2) + 7, STEP * 3.2);
      }
      const ev = EV[sc];
      if (ev) {                               // 主旋律
        bell(nextTime, ev.d, ev.len * STEP * 0.96, (0.125 + R() * 0.03) * swell);
        if (ev.len >= 4 && R() < 0.5)         // 长音上叠三度或高八度闪光
          bell(nextTime + STEP * 0.5, R() < 0.5 ? ev.d + 4 : ev.d + 12, ev.len * STEP * 0.6, 0.045 * swell);
      }
      if (bc >= 8) {                          // B 段：竖琴琶音 + 轻打击
        const arpT = tones[[0, 2, 3, 2][sc % 4]] + 12;
        harp(nextTime, arpT, 0.026 * swell);
        if (sc % 8 === 2 || sc % 8 === 6) tick(nextTime, 0.016);
      }
      nextTime += STEP;
      step++;
      if (step % CYCLE_STEPS === 0) cycle++;
    }
  }
  return {
    init() {
      try {
        const o = localStorage.getItem('xiantu-music-on');
        if (o !== null) on = o !== '0';
        const v = parseFloat(localStorage.getItem('xiantu-music-vol'));
        if (!isNaN(v)) vol = clamp(v, 0, 1);
      } catch (e) {}
    },
    unlock() {                                  // 必须在用户手势后调用
      if (!on || !build()) return;
      if (ctx.state === 'suspended' && ctx.resume) ctx.resume();
      if (!running) {
        running = true;
        nextTime = Math.max(nextTime, ctx.currentTime + 0.1);
        if (!timer) timer = setInterval(schedule, 260);
        schedule();
      }
    },
    toggle() {
      on = !on;
      try { localStorage.setItem('xiantu-music-on', on ? '1' : '0'); } catch (e) {}
      if (on) { this.unlock(); if (master && ctx) master.gain.setTargetAtTime(vol, ctx.currentTime, 0.4); }
      else { this.duck(0.6); running = false; if (timer) { clearInterval(timer); timer = null; } }
      return on;
    },
    setVolume(v) {
      vol = clamp(v, 0, 1);
      try { localStorage.setItem('xiantu-music-vol', String(vol)); } catch (e) {}
      if (master && ctx) master.gain.setTargetAtTime(on ? vol : 0, ctx.currentTime, 0.15);
    },
    duck(sec) { if (master && ctx) master.gain.setTargetAtTime(0.0001, ctx.currentTime, (sec || 1.5) / 3); },
    resume() { if (on && master && ctx) master.gain.setTargetAtTime(vol, ctx.currentTime, 0.8); },
    fadeOut() {
      if (!ctx) return;
      this.duck(2.2);
      setTimeout(() => { running = false; if (timer) { clearInterval(timer); timer = null; } }, 2400);
    },
    get on() { return on; },
    get vol() { return vol; },
  };
})();

/* ---------------- 初始化 ---------------- */
function init() {
  // 粒子
  const cv = $('fx'), ctx = cv.getContext('2d');
  let W, H, motes = [];
  function resize() { W = cv.width = innerWidth; H = cv.height = innerHeight; }
  resize(); addEventListener('resize', resize);
  for (let i = 0; i < 55; i++) motes.push({ x: R() * innerWidth, y: R() * innerHeight, r: 0.6 + R() * 2.2, sp: 0.12 + R() * 0.4, ph: R() * 6.28 });
  (function loop() {
    ctx.clearRect(0, 0, W, H);
    for (const m of motes) {
      m.y -= m.sp; m.ph += 0.01; m.x += Math.sin(m.ph) * 0.3;
      if (m.y < -10) { m.y = H + 10; m.x = R() * W; }
      ctx.beginPath(); ctx.arc(m.x, m.y, m.r, 0, 6.28);
      ctx.fillStyle = `rgba(216,180,90,${0.14 + Math.sin(m.ph) * 0.08})`;
      ctx.fill();
    }
    requestAnimationFrame(loop);
  })();

  renderPreview();
  $('in-name').value = randName();
  descLine();
  applyBuild('jian');
  document.querySelectorAll('#build-row .build-btn').forEach(b => b.onclick = () => { applyBuild(b.dataset.b); });
  bakeMaleVariants();
  probeMaleOverrides();

  /* 背景音乐：开关 + 音量 + 首个手势后解锁（浏览器自动播放策略） */
  Music.init();
  const mBtn = $('btn-music'), mVol = $('music-vol');
  const syncMusicUI = () => {
    if (mBtn) { mBtn.textContent = Music.on ? '🔊 配乐' : '🔇 静音'; mBtn.classList.toggle('on', Music.on); }
    if (mVol) mVol.value = Math.round(Music.vol * 100);
  };
  if (mBtn) mBtn.onclick = () => { Music.toggle(); syncMusicUI(); };
  if (mVol) mVol.oninput = e => Music.setVolume(+e.target.value / 100);
  syncMusicUI();
  const unlockOnce = () => {
    try { Music.unlock(); } catch (e) {}
    removeEventListener('pointerdown', unlockOnce);
    removeEventListener('keydown', unlockOnce);
  };
  addEventListener('pointerdown', unlockOnce);
  addEventListener('keydown', unlockOnce);
  document.addEventListener('visibilitychange', () => {
    try { if (document.hidden) Music.duck(0.4); else if (Music.on) Music.resume(); } catch (e) {}
  });

  $('seg-gender').querySelectorAll('.btn').forEach(b => b.onclick = () => {
    $('seg-gender').querySelectorAll('.btn').forEach(x => x.classList.remove('on'));
    b.classList.add('on');
    startGender = b.dataset.g;
    renderPreview();
  });
  $('in-origin').onchange = () => { descLine(); applyBuild(buildKey); };
  $('in-talent').onchange = () => { descLine(); applyBuild(buildKey); };
  /* 平板/手机：全屏 + 横屏锁定（不支持的浏览器静默忽略） */
  const fsBtn = $('btn-fs');
  if (fsBtn) fsBtn.onclick = () => {
    const d = document, el = d.documentElement;
    const req = el.requestFullscreen || el.webkitRequestFullscreen || el.msRequestFullscreen;
    const exit = d.exitFullscreen || d.webkitExitFullscreen || d.msExitFullscreen;
    const fsEl = d.fullscreenElement || d.webkitFullscreenElement;
    if (!fsEl) {
      if (req) { const p = req.call(el); if (p && p.catch) p.catch(() => {}); }
      try { if (screen.orientation && screen.orientation.lock) screen.orientation.lock('landscape'); } catch (e) {}
      fsBtn.textContent = '⛶ 退出全屏';
    } else {
      if (exit) { const p = exit.call(d); if (p && p.catch) p.catch(() => {}); }
      fsBtn.textContent = '⛶ 全屏';
    }
  };
  $('btn-randname').onclick = () => { $('in-name').value = randName(); renderPreview(); };
  $('btn-randall').onclick = randomizeStart;
  $('btn-start').onclick = startGame;
  $('btn-continue').onclick = () => {
    const d = loadGame();
    if (!d) {
      const el = $('desc-line');
      if (el) el.innerHTML = '<b style="color:#e06c75">没有找到前世存档——本局尚无进度，或浏览器禁用了本地存储。</b>';
      return;
    }
    s = d;
    if (!s.flags) s.flags = {};
    if (s.gift === undefined) s.gift = 10;
    $('scr-start').classList.add('hidden');
    $('scr-game').classList.remove('hidden');
    $('log').innerHTML = '';
    phase = 'action'; queue = []; current = null;
    log(`前尘如梦。${s.name}·${s.age}岁·${REALMS[s.realm].name}，继续这一世。`, 'big');
    renderPanel(); renderActions();
  };
  if (loadGame()) { $('btn-continue').style.display = ''; } else { $('btn-continue').style.display = 'none'; }
  $('btn-fast').onclick = fastForward;
  $('btn-restart').onclick = () => { localStorage.removeItem(SAVE_KEY); location.reload(); };
  $('btn-again').onclick = () => { localStorage.removeItem(SAVE_KEY); location.reload(); };
  $('btn-lookback').onclick = () => {
    $('scr-end').classList.add('hidden');
    $('scr-game').classList.remove('hidden');
    phase = 'end';
  };
}
init();
