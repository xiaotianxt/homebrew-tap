class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "1.4.25"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.25/tg-v1.4.25-darwin-arm64.tar.gz"
      sha256 "332ca502ac14b80aa29222454a3489e16b526c1de397daf1c5784406f44c58a8"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.25/tg-v1.4.25-linux-arm64.tar.gz"
      sha256 "79d8c19a4c320151ee26382eb1275261a491579fd349cbc4bf5eab9e7604e6e1"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v1.4.25/tg-v1.4.25-linux-x86_64.tar.gz"
      sha256 "dcbf60d017897f606abf8e166cd0621f7cb030c9b50bc1bc030a586017f46bc3"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method lldb-cold` uses Apple's lldb/debugserver.
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
