class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.9.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.0/tg-v2.9.0-darwin-arm64.tar.gz"
      sha256 "5f66571be48f80bb3fabbd0768662c67bc8dfe87f62a47605884eda99daee074"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.0/tg-v2.9.0-linux-arm64.tar.gz"
      sha256 "957e33703587c895f08a0cac2024b62374d462a6f3e364dd165200aff9d5df1f"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.9.0/tg-v2.9.0-linux-x86_64.tar.gz"
      sha256 "afe051bea1443095516c1a70e742610e0b80176d3ff729d94593b247cca998c0"
    else
      odie "unsupported Linux architecture"
    end
  end

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
