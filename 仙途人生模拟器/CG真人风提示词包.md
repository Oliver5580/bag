# 仙途人生模拟器 · 女主真人风 CG 提示词包

按 `anime-to-real` skill 规范输出：纯英文、8 段式 + 扁平版、东亚审美锚定。
尺度约定：**含蓄浪漫** —— 婚仪、烛光、执手、回眸即可，；未成年情节（情窦初开）只用 pure / innocent 类词汇。

> **CG 动画标准**（对齐参考：AI 漫剧风）：CG 不是静图 —— 内置版本自带人物呼吸浮动、入场均机、
> 鼠标视差、对白字幕条；若你用 AI 视频工具（可灵 / 即梦 / Vidu / Runway 等）生成了动态 CG，
> 按 **`cg-<场景键>.mp4`（或 .webm）** 命名放入 `assets/`，游戏会**直接播放视频**作为该场景 CG
> （静图 `cg-<场景键>.png` 优先级次于视频，均高于内置场景）。给指定女主单独出片用
> `cg-<场景键>-<编号>.mp4`。视频建议 9:16~16:9 横构图、5~10 秒、可无缝循环。

---

## 一、怎么用（两步）

1. 把下面的提示词粘贴到 Midjourney / Stable Diffusion / Flux 生图（建议竖版 3:4 或 2:3，人物半身）。
2. 生成后把图片放进 `assets/` 文件夹，游戏会**自动替换**对应 CG（找不到图片时用内置手绘场景）。

### 场景键 → 文件名

| 场景键 | 剧情 | 存图文件名 |
|---|---|---|
| `firstlove` / `m_firstlove` | 情窦初开 · 巷口桃花 | `cg-firstlove.png` |
| `enc0` | 灯会惊鸿 | `cg-enc0.png` |
| `enc1` | 山道遇匪 | `cg-enc1.png` |
| `enc2` | 秘境邂逅 | `cg-enc2.png` |
| `enc3` | 夜市迷香 | `cg-enc3.png` |
| `enc4` | 病榻之恩 | `cg-enc4.png` |
| `enc5` | 仙盟大典 | `cg-enc5.png` |
| `enc6` | 客栈夜雨 | `cg-enc6.png` |
| `propose` | 道侣大典 · 永结同心 | `cg-propose.png` |
| `birth` | 添丁之喜 | `cg-birth.png` |
| `shuangxiu` | 双修共渡 | `cg-shuangxiu.png` |

想为**指定女主**出图，把文件名加上编号：`cg-propose-5.png`（金袍女帝的大婚）。
不指定编号的 `cg-<场景键>.png` 对所有女主生效。

### 女主编号对照

| 编号 | 女主 | 立绘 |
|---|---|---|
| 0 | 白衣少女 · 温婉 | `portrait-f.png` |
| 1 | 红衣女将 · 飒爽 | `portrait-f-red.png` |
| 2 | 银发仙子 · 清冷 | `portrait-f-blue.png` |
| 3 | 紫衣妖姬 · 妩媚 | `portrait-f-purple.png` |
| 4 | 绿裙药师 · 灵动 | `portrait-f-green.png` |
| 5 | 金袍女帝 · 华贵 | `portrait-f-gold.png` |
| 6 | 黑衣女侠 · 侠气 | `portrait-f-dark.png` |

浏览器控制台输入 `__cg('propose', 5)` 可直接预览任意 CG（第 2 参为女主编号，第 3 参填 `true` 看女角色玩家视角）。

---

## 二、七位女主 · 角色基础提示词（[Character] 段）

拼接时整段复制到提示词开头。均含东亚审美锚定词（skill 规则 1）。

**0 白衣少女**
```
[Character] A photorealistic beautiful young woman with East Asian beauty, faithful to the
game heroine — fair luminous porcelain skin, delicate refined features, long silky black hair
partly tied with a black silk ribbon, warm brown eyes, gentle brows; elegant black hanfu-style
gown with gold filigree embroidery and white lace shoulders, gold floral earrings with pearl
and blue beads; soft, warm, gentle grace.
```
扁平：`1girl, solo, photorealistic beautiful East Asian woman, fair luminous skin, long black hair with black ribbon, brown eyes, black and gold embroidered hanfu, white lace shoulders, gold pearl earrings, gentle graceful`

**1 红衣女将**
```
[Character] A photorealistic beautiful woman with East Asian beauty, faithful to the game
heroine — fair porcelain skin, delicate refined features, long black hair adorned with a gold
phoenix hairpin and red tassel strands, bright amber eyes, a tiny beauty mark; crimson and
gold high-collared battle robe with ornate gold filigree, red-and-gold floral earrings;
valiant, radiant, heroic grace.
```
扁平：`1girl, solo, photorealistic East Asian beauty, fair skin, long black hair, gold phoenix hairpin with red tassels, amber eyes, crimson and gold high-collar battle robe, valiant heroic`

**2 银发仙子**
```
[Character] A photorealistic ethereally beautiful woman with East Asian beauty, faithful to
the game heroine — fair translucent porcelain skin, delicate refined features, long silver-white
hair with an icy-blue gradient falling to her waist, pale blue-grey eyes; white cloud-shaped
jade hairpin with strands of pearls, white-and-blue celestial robes with a dark blue gold-trimmed
collar, gold and pearl earrings; cool, otherworldly, serene.
```
扁平：`1girl, solo, photorealistic East Asian beauty, fair translucent skin, long silver-white hair with icy blue gradient, pale blue eyes, white celestial hanfu, pearl hairpin strands, ethereal serene`

**3 紫衣妖姬**（成年角色，适度妩媚，有品位克制）
```
[Character] A photorealistic alluring woman with East Asian beauty, faithful to the game
heroine — fair luminous skin, delicate refined features, long dark-brown hair tied with a
black ribbon, captivating violet eyes, soft smile; high-collared black gown with purple and
gold ornate trim, amethyst pendant at the collarbone, gold floral earrings with blue drops;
elegant, subtly bewitching, tasteful.
```
扁平：`1girl, solo, photorealistic East Asian beauty, fair skin, long dark brown hair with black ribbon, violet eyes, black gown with purple gold trim, amethyst pendant, elegant alluring, tasteful`

**4 绿裙药师**
```
[Character] A photorealistic lovely young woman with East Asian beauty, faithful to the game
heroine — fair fair skin, delicate refined features, long flowing green hair pinned with pink
blossoms, clear green eyes, bright gentle smile; green hanfu with gold vine embroidery, white
inner sleeves, gold flower earrings with jade drops; fresh, lively, healing warmth.
```
扁平：`1girl, solo, photorealistic East Asian beauty, fair skin, long green hair with pink blossoms, green eyes, green hanfu with gold embroidery, jade earrings, lively innocent, healing`

**5 金袍女帝**
```
[Character] A photorealistic majestic beautiful woman with East Asian beauty, faithful to the
game heroine — fair porcelain skin, refined noble features, long dark hair beneath an elaborate
gold phoenix crown with hanging bead strands, amber-brown eyes; golden imperial robe with black
embroidered collar and gold relief patterns, gold floral earrings with blue beads; regal,
composed, imperial majesty.
```
扁平：`1girl, solo, photorealistic East Asian beauty, fair skin, gold phoenix crown with bead strands, amber eyes, golden imperial robe with black collar, regal majestic`

**6 黑衣女侠**
```
[Character] A photorealistic strikingly beautiful woman with East Asian beauty, faithful to
the game heroine — fair porcelain skin, sharp delicate features, long black hair in a high
ponytail with a crimson headband ribbon, cool grey eyes with red-tinted lashes; black high-collar
warrior armor with silver filigree and red sashes, gold chain ornaments and silver drop earrings;
cold, restrained, swordswoman aura.
```
扁平：`1girl, solo, photorealistic East Asian beauty, fair skin, black high ponytail, crimson headband ribbon, grey eyes, black warrior armor with red sash, cool heroic`

---

## 三、11 个 CG 场景模板

拼装公式：**[Character 段] + [Scene 段] + [Lighting 段] + [Camera 段] + [Quality 段]**。
扁平等价：`扁平 Character 串 + 场景串 + 质量串`。

**firstlove 巷口桃花**（青梅年少 —— 只用纯真词汇）
```
[Scene & Setting] A quiet old-town lane in spring, themed in soft pink and cream — whitewashed
houses with grey-tiled roofs, a peach branch heavy with pink blossoms stretching over the lane,
petals drifting in the warm breeze.
[Expression] Innocent and shy, eyes curved in a bright pure smile, faint blush.
[Lighting & Color] Gentle afternoon sunlight, warm pink-cream palette, soft shadows.
[Camera & Composition] Eye-level shot down the lane, character at the right third, petals
floating in the foreground, vertical 3:4.
[Quality & Style] masterpiece, best quality, ultra-detailed, photorealistic, cinematic
lighting, depth of field, soft bokeh, sharp focus, hyperrealistic skin texture, lifelike
fabric details, realistic sunlight rendering, wallpaper-grade composition
```

**enc0 灯会惊鸿**
```
[Scene & Setting] A bustling lantern festival night, themed in indigo purple and warm orange —
strings of glowing red and orange lanterns overhead, moon high in a star-scattered sky, festival
stall silhouettes below.
[Expression] A quiet gasp of wonder, eyes lit by lantern glow, lips slightly parted.
[Lighting & Color] Warm lantern light as key light from above, cool indigo night as fill,
gold-and-violet contrast.
[Camera & Composition] Slight low angle, character at right, lantern bokeh around, 3:4.
[Quality] 同上质量段
```

**enc1 山道遇匪**
```
[Scene & Setting] A remote mountain road at dusk, themed in rose-amber — layered dark ridges,
a low burning sun on the horizon, wind-swept grass, faint glints of blades in the air.
[Expression] Fearless and calm, a protective stance, eyes sharp toward the distance.
[Lighting & Color] Dusk sun as rim light, deep rose shadows, amber highlights.
[Camera & Composition] Wide cinematic shot, character right, road winding to the left, 3:4.
```

**enc2 秘境邂逅**
```
[Scene & Setting] A secret realm above a sea of clouds, themed in jade teal — floating mountain
peaks with thin waterfalls, a pale jade moon with halo rings, drifting cloud banks.
[Expression] Serene detachment, gaze like frost over clouds, faint curiosity.
[Lighting & Color] Moonlight as cool key light, cyan rim light, jade-white palette.
[Camera & Composition] Eye level among the clouds, character right, peaks left, 3:4.
```

**enc3 夜市迷香**
```
[Scene & Setting] A raucous night market, themed in plum purple and lantern red — rows of red
lanterns, stall awnings with warm lamplight, a hanging wooden sign, drifting purple haze.
[Expression] Playful knowing smile, eyes glancing sideways over a raised cup, charming but tasteful.
[Lighting & Color] Red lantern glow as warm key, purple night ambience, soft haze.
[Camera & Composition] Mid shot across a stall, character right, lanterns framing above, 3:4.
```

**enc4 病榻之恩**
```
[Scene & Setting] A warm herbalist's hut interior at night, themed in umber and lamp amber —
a moonlit paper window, hanging herb bundles, shelves of medicine jars, a steaming medicine
bowl on the table.
[Expression] Gentle concern, tending care in the eyes, soft warm smile.
[Lighting & Color] Warm oil-lamp key light, cool moonlight from the window as fill.
[Camera & Composition] Intimate indoor mid shot, character right, window and jars left, 3:4.
```

**enc5 仙盟大典**
```
[Scene & Setting] A grand immortal-alliance ceremony hall, themed in royal blue and gold —
towering pillars, hanging crimson banners with gold trim, a golden glow overhead, drifting
golden motes.
[Expression] Composed regal poise, chin slightly raised, commanding yet graceful.
[Lighting & Color] Golden ceremonial glow from above, blue hall ambience, stately contrast.
[Camera & Composition] Wide low-angle hall shot, character right between pillars, 3:4.
```

**enc6 客栈夜雨**
```
[Scene & Setting] A roadside inn on a rainy night, themed in slate blue and warm amber — a
large wooden-framed window with rain streaks outside, a faint lightning glow, a lamp and a
cup of tea on the table.
[Expression] Wary coolness softening into trust, damp strands of hair, quiet eyes.
[Lighting & Color] Warm interior lamp key, cold blue rain light from the window.
[Camera & Composition] Interior mid shot, character right near warm glow, window left, 3:4.
```

**propose 道侣大典 · 永结同心**（成年婚仪，含蓄喜庆）
```
[Scene & Setting] A crimson-gold wedding hall, themed in deep red and gold — silk canopy with
gold trim, paired red lanterns, twin candles with soft flames, a golden 囍 character on a round
glow, red petals drifting.
[Expression] Tender joy with shy dignity, eyes meeting her partner's, gentle blush.
[Lighting & Color] Candle-warm key light, crimson ambience, gold accents everywhere.
[Camera & Composition] Waist-up shot, character right, candles and 囍 left, petals in
foreground, 3:4.
```

**birth 添丁之喜**
```
[Scene & Setting] A warm home interior in honeyed morning light, themed in honey brown and
cream — sunbeams through a latticed window, a wooden cradle with a hanging rattle, a vase of
plum blossoms, floating dust motes.
[Expression] Soft maternal warmth, tired happy eyes, a gentle smile at the cradle.
[Lighting & Color] Golden morning beams as key, warm homely palette.
[Camera & Composition] Cozy indoor shot, character right, cradle and window left, 3:4.
```

**shuangxiu 双修共渡**（成年道侣，静坐论道式含蓄表达）
```
[Scene & Setting] A quiet meditation chamber at night, themed in deep teal — a glowing
yin-yang taiji sigil on the floor with concentric rings, two seated meditation silhouettes
facing each other, luminous energy ribbons arcing between their hands, floating glyph lights.
[Expression] Tranquil focus, eyes closed, serene and composed.
[Lighting & Color] Cool cyan-purple spirit glow as key, dark chamber ambience.
[Camera & Composition] Wide symmetric shot, sigil center-left, character right, 3:4.
```

---

## 四、完整拼装范例（enc0 × 白衣少女）

```
[Character] A photorealistic beautiful young woman with East Asian beauty, faithful to the
game heroine — fair luminous porcelain skin, delicate refined features, long silky black hair
partly tied with a black silk ribbon, warm brown eyes; elegant black hanfu-style gown with
gold filigree embroidery and white lace shoulders, gold floral earrings with pearl and blue
beads; soft, warm, gentle grace.

[Scene & Setting] A bustling lantern festival night, themed in indigo purple and warm orange —
strings of glowing red and orange lanterns overhead, moon high in a star-scattered sky.

[Expression] A quiet gasp of wonder, eyes lit by lantern glow.

[Lighting & Color] Warm lantern light as key from above, cool indigo night as fill.

[Camera & Composition] Slight low angle, character at right, lantern bokeh around, vertical 3:4.

[Quality & Style] masterpiece, best quality, ultra-detailed, 1girl, solo, photorealistic,
cinematic lighting, depth of field, soft bokeh, sharp focus, hyperrealistic skin texture,
lifelike fabric details, realistic lantern-light rendering, wallpaper-grade composition
```

扁平版：
```
masterpiece, best quality, ultra-detailed, 1girl, solo, photorealistic, cinematic lighting,
depth of field, soft bokeh, sharp focus, hyperrealistic skin texture, a beautiful East Asian
woman with fair luminous skin, long black hair with black ribbon, brown eyes, black and gold
embroidered hanfu with white lace shoulders, gold pearl earrings, standing under glowing red
lanterns at a bustling night festival, indigo sky and full moon, warm lantern glow, slight low
angle, lantern bokeh, 8K ultra-detailed
```

---

## 五、CG 动画 · AI 视频生成提示词（按参考漫剧标准）

用「图生视频」工作流：先按上文提示词出**角色立绘图**，再把立绘 + 下面的运动描述喂给视频工具。
每条 = 镜头运动 + 人物待机动作 + 环境动态，5~10 秒循环。中文描述兼容可灵/即梦，英文兼容 Runway。

| 场景 | 视频运动提示词 |
|---|---|
| firstlove | 镜头缓慢右移轻推近，少女微风吹拂发丝与裙摆，轻抿嘴浅笑，桃花瓣持续飘落，光斑闪烁 |
| enc0 | 镜头缓慢上摇再推近人物，灯笼轻轻摇曳发光，人物回眸眨眼，发丝飘动，人群虚化走动 |
| enc1 | 低角度缓慢推近，斗篷猎猎作响，人物按剑回头，草浪起伏，晚霞云层流动 |
| enc2 | 镜头环绕人物半圈缓推，云海翻涌流动，发带与裙摆飘扬，月光光晕呼吸闪烁 |
| enc3 | 镜头轻微手持感晃动推近，人物转身挑眉轻笑，灯笼光影在脸上晃动，烟雾缭绕 |
| enc4 | 镜头缓慢横移推近，药炉热气袅袅上升，人物低头搅药抬头微笑，烛火摇曳 |
| enc5 | 镜头从地面缓慢升起至仰角，金色粒子飘落，人物凤冠流苏轻晃，衣袂展开 |
| enc6 | 镜头静止微推，窗外雨丝斜落，闪电微光扫过，人物拨发侧头，烛光忽明忽暗 |
| propose | 镜头缓慢推近人物面部，红绸与发丝轻扬，烛火跳动，花瓣缓落，人物垂眸一笑 |
| birth | 镜头缓慢推近，晨光光柱中尘埃浮动，摇篮挂铃轻晃，人物俯身凝视微笑 |
| shuangxiu | 镜头缓慢环绕，太极图光晕旋转呼吸，能量丝带流动，两人发丝衣角被气浪轻托 |

英文模板（替换场景词即可）：
```
slow cinematic dolly-in, the woman breathes gently with subtle hair and fabric sway,
she blinks and turns her head slightly with a soft expression, ambient particles drifting,
atmospheric light flickering, seamless loop, anime 3D render style, high detail
```

---

## 六、男主立绘 · 每一世随机建模

游戏内置 8 套程序化变体（镜像×构图×色调），每世随机。
想要**真正不同的人设立绘**：按下面提示词生成 8 张男主立绘，命名为
`portrait-m-0.png` ~ `portrait-m-7.png` 放入 `assets/`，游戏启动时自动启用
（编号对应下表；没放全也没关系，缺的编号用内置变体补位）。

| 编号 | 人设 | 造型关键词 |
|---|---|---|
| 0 | 墨金剑客 | 黑金云纹劲装，高马尾，背剑 |
| 1 | 玄青刀客 | 玄青色刀袍，散发披肩，腰悬长刀 |
| 2 | 绯焰枪修 | 绯红暗纹战袍，束发红缨，长枪 |
| 3 | 霜白衣修 | 月白广袖仙袍，玉冠束发，素雅 |
| 4 | 黛紫琴师 | 黛紫绣银长袍，半束发，负琴 |
| 5 | 鎏金公子 | 鎏金锦袍，金冠，世家气度 |
| 6 | 翡翠药修 | 竹青色道袍，背负药篓，清瘦 |
| 7 | 烟灰游侠 | 烟灰色短打劲装，斗笠，风尘感 |

男主角色提示词模板（替换造型关键词即可）：
```
[Character] A photorealistic handsome young man with East Asian beauty — fair skin, refined
masculine features, sharp elegant brows and deep brown eyes, tall upright bearing; 【造型关键词】;
xianxia cultivator, dignified and resolute aura.
[Quality & Style] masterpiece, best quality, ultra-detailed, 1boy, solo, photorealistic,
cinematic lighting, depth of field, sharp focus, hyperrealistic skin texture, lifelike
fabric details, vertical 3:4 portrait, clean dark background
```
扁平版：`1boy, solo, photorealistic handsome East Asian man, fair skin, refined masculine features, 【造型关键词】, xianxia cultivator, dark clean background, 8K ultra-detailed`

---

## 七、尺度与安全说明

- 全部场景为**含蓄浪漫**表达：婚仪、烛光、执手、回眸、静坐论道；提示词不含任何露骨词汇。
- `firstlove`（情窦初开）剧情角色为年少相识，提示词仅用 innocent / pure / shy 类词汇。
- skill 硬规则已内置：东亚审美锚定（fair luminous porcelain skin / delicate refined features）、
  禁用 tanned skin / chiseled jawline 等欧美刻板词；成年角色最多 tasteful 级的 alluring。
