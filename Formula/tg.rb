class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "3.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.0.1/tg-v3.0.1-darwin-arm64.tar.gz"
      sha256 "77e5a0da7496a5980e4c27f907924218ce4bfe0319e05f101c9380f952645215"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.0.1/tg-v3.0.1-linux-arm64.tar.gz"
      sha256 "221216be7ddd11a8adcba0d245a392381ca388f4f12154794a4aae065b290eb2"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.0.1/tg-v3.0.1-linux-x86_64.tar.gz"
      sha256 "c11818cd36189ff746749e8c4a1544c53d00f693c853518750d475c08ee02716"
    else
      odie "unsupported Linux architecture"
    end
  end

  depends_on "ffmpeg"
  depends_on "rust-" + "si" + "lk"

  def caveats
    <<~EOS
      `tg keys --method login` uses LLDB on macOS or GDB on Linux while you log out and back in once.
      Install Apple Command Line Tools on macOS, or GDB on Linux, when that mode is needed.
    EOS
  end

  def install
    bin.install "tg"
    doc.install "LICENSE", "THIRD_PARTY_LICENSES"
    generate_completions_from_executable(bin/"tg", "completions")
  end

  test do
    system bin/"tg", "--version"
  end
end
