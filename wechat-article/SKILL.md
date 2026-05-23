---
name: wechat-article
description: "Summarizes WeChat articles. Triggers when user sends a mp.weixin.qq.com article link. Use Playwright with playwright_stealth to bypass WeChat verification and extract article content."
---

# 微信文章总结 skill

## 抓取流程

**必须使用 playwright + playwright_stealth 绕过微信验证码！**

### 完整代码

```python
import sys
from playwright.sync_api import sync_playwright
from playwright_stealth import Stealth
import time

url = 'https://mp.weixin.qq.com/s?__biz=...'

# 确保输出编码为 UTF-8
sys.stdout.reconfigure(encoding='utf-8')

stealth = Stealth()

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()

    # 关键：应用 stealth 绕过微信验证码
    stealth.apply_stealth_sync(page)

    page.goto(url, timeout=30000)
    time.sleep(12)  # 等待页面加载

    # 获取文章标题
    title = page.title()
    print(f'标题: {title}')

    # 获取文章正文
    article = page.locator('#js_content').inner_text(timeout=15000)
    print(f'正文长度: {len(article)}')
    print(article)

    context.close()
    browser.close()
```

## 注意事项

| 要点 | 说明 |
|------|------|
| **必须用 stealth** | 否则微信验证码会拦截 |
| **sleep 时间** | 微信加载慢，至少等待12秒 |
| **编码问题** | Windows 下需要 `sys.stdout.reconfigure(encoding='utf-8')` |
| **headless=False** | 无头模式更容易被拦截 |
| **超时设置** | page.goto 超时 30秒，正文提取超时 15秒 |

## 输出格式

文章抓取成功后，按以下格式总结：

**标题**：

**来源**：微信公众号名称

**主要观点**：
1. 第一点
2. 第二点
3. 第三点
...

**关键信息**：
- 信息点1
- 信息点2

**作者/来源**：底部信息（如有）

---

## 依赖安装

如遇 playwright 未安装浏览器：
```bash
python -m playwright install chromium
```

如遇 playwright_stealth 未安装：
```bash
pip install playwright-stealth
```