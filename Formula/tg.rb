class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.1.0/tg-v2.1.0-darwin-arm64.tar.gz"
      sha256 "6f0d5b4314caf6d203a7360fec25d41b7e4ae302f4565e513793e80c344d803e"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.1.0/tg-v2.1.0-linux-arm64.tar.gz"
      sha256 "e16d0a6b971715f27b11b2446e33a80d40188ea607528f821c3554aa88ed14d7"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.1.0/tg-v2.1.0-linux-x86_64.tar.gz"
      sha256 "396cbbfe0ec7717939f2132d58dc35b97f6b328efddbeaf6ba65ea3f9bb73513"
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
