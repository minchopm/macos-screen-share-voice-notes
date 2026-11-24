# macOS Screen-Share Exclusion & Bot-Free Voice Workspace Reference

Architectural reference notes and Swift snippets for building **opt-in macOS screen-share window exclusion** (`NSWindow.SharingType.none` + `ScreenCaptureKit` self-exclusion) alongside bot-free system audio and local Apple silicon speech/LLM inference.

Extracted from production engineering on **[GPT Realtime Assistant](https://gpt-realtime-assistant.arte-soft.com/)** (`v1.2.3` for iPhone, iPad, and Apple silicon Mac — [App Store `id6770536523`](https://apps.apple.com/us/app/gpt-realtime-assistant/id6770536523)).

---

## Why Opt-In (`Visible` by Default) Matters

Always-hidden desktop overlays break everyday developer ergonomics: they vanish from `Command-Tab`, disappear from bug-report screenshots, and surprise teammates during collaborative pairing.

In **GPT Realtime Assistant** on Mac (`macOS 26+`, Apple silicon), the **`Hide app`** button in the Live toolbar starts **off** (`Visible to screen sharing`). When presenting full-screen on a single 13-inch or 14-inch MacBook display in Zoom, Google Meet, or Microsoft Teams, one click enables three coordinated AppKit & `ScreenCaptureKit` behaviors:

1. **`NSWindow.sharingType = .none`** — instructs macOS `WindowServer` to omit the host windows from standard `ScreenCaptureKit` and `CGWindowList` display broadcasts and `Command-Shift-3` screenshots.
2. **`.floating` window level + `.fullScreenAuxiliary`** — keeps your compact live transcript and briefing notes readable near the top-center webcam when clicking into Keynote, Chrome, Xcode, or Figma.
3. **`SCContentFilter(display:excludingApplications:)`** — excludes the app's own bundle when capturing visual screen context (**Screenshot** / **Record**), preventing "hall-of-mirrors" recursion.

---

## 2026 macOS Bot-Free Call & Screen-Share Architecture Matrix

| Capability | GPT Realtime Assistant (`v1.2.3`) | Granola | MacWhisper | Typical Bot Recorders (Otter / Fireflies) |
| :--- | :--- | :--- | :--- | :--- |
| **Call Audio Capture** | Local macOS `ScreenCaptureKit` (0 call bots) | Local Mac audio (0 call bots) | Local file / mic (0 call bots) | Calendar bot joins participant list |
| **Mac Screen-Share Exclusion** | **Opt-in `Hide app` (`NSWindow.sharingType = .none`)** | Normal visible window | Normal visible window | Browser / web dashboard |
| **Live Mid-Call AI Answers** | **Yes — side-by-side beside running transcript** | Post-call summary focus | Post-recording Q&A | Post-call summary focus |
| **Offline Apple Silicon AI** | **Whisper Large v3 Turbo + Qwen 3 8B** (`0` credits) | Cloud required | Local Whisper STT | Cloud only |
| **58-Language 2-Way Interpreter** | **Yes — iPhone, iPad & Mac** | No | No live 2-way spoken mode | No |
| **Pre-Recorded File Upload / Export** | No (live while open only; local Tasks/Notes) | Automated cloud notes | **Yes — MP3/MP4/WAV + SRT/VTT** | Cloud uploads & exports |
| **Pricing** | **$9.99/mo** (2,000 credits) or **$119.99/yr** (30,000 credits) | Per-seat SaaS | One-time / Pro | Per-seat SaaS |

---

## Honest Technical & Physical Boundaries

- **Excluded (`Yes`):** Zoom, Google Meet, Microsoft Teams, Slack Huddles, Webex, Discord, QuickTime / OBS macOS Screen Capture, and `Command-Shift-3` / `Command-Shift-4` screenshots.
- **Not excluded — Acoustic loudspeaker audio:** Wear headphones or mute spoken replies during calls so MacBook speakers never bleed into the microphone.
- **Not excluded — System mouse cursor:** macOS still broadcasts pointer coordinates over the shared desktop.
- **Not excluded — Hardware HDMI capture & cameras:** External cameras and inline HDMI capture cards record physical display output, and exam-proctoring tools inspect processes directly (where external assistance is prohibited). Always obtain required recording/transcription consent.

---

## Related Guides & Engineering Articles

- [How to Hide GPT Realtime Assistant During Mac Screen Sharing ('Hide app' Mode Explained)](https://gpt-realtime-assistant.arte-soft.com/articles/hide-app-window-during-mac-screen-sharing/)
- [Best Cluely Alternatives for Mac Screen Sharing in 2026](https://gpt-realtime-assistant.arte-soft.com/articles/cluely-alternatives-for-mac-screen-sharing-2026/)
- [Granola vs MacWhisper vs GPT Realtime Assistant (2026)](https://gpt-realtime-assistant.arte-soft.com/articles/granola-vs-macwhisper-vs-gpt-realtime-assistant-mac-2026/)
- [Offline Voice AI on Apple Silicon Mac: Whisper Large v3 Turbo + Qwen 3 8B](https://gpt-realtime-assistant.arte-soft.com/articles/offline-apple-silicon-voice-ai-whisper-qwen-comparison-2026/)
- [Interactive Product Portal & Workflows](https://realtime-assistant.arte-soft.com/)
- [Official Documentation Hub](https://minchopm.github.io/gpt-realtime-assistant-docs/)
- [Engineering Blog (Hashnode)](https://artesoft.hashnode.dev/excluding-live-ai-notes-from-macos-screen-sharing-screencapturekit)
