class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.5.0/tg-v1.5.0-darwin-arm64.tar.gz"
      sha256 "5716d7784a47cd55c9585b60c79779822a6f303bf774219bb9d5acfa0904279c"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.5.0/tg-v1.5.0-linux-arm64.tar.gz"
      sha256 "3e6a8aae334120d5e6ff320e52cd96a41180653daf00012258e485230d15c4d5"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.5.0/tg-v1.5.0-linux-x86_64.tar.gz"
      sha256 "6268d85dd6fb9d2d260ddd98a9599d3e1379da637612c39f62abbf31ecea2e49"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method lldb-login` uses Apple's lldb/debugserver while you log out and back in once.
      Install Apple Command Line Tools when that mode is needed:
        xcode-select --install
    EOS
  end

  def install
    bin.install "tg"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
