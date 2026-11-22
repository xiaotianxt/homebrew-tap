class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "3.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.0.0/tg-v3.0.0-darwin-arm64.tar.gz"
      sha256 "0a0fb3ccd8828e1f8c26682405d7e68f19a887f9fd01102177a7238c202dc790"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.0.0/tg-v3.0.0-linux-arm64.tar.gz"
      sha256 "3432636f839b5555482f4e423681e94fa4df3fcb1d6f9bb50dcc4f5892512666"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v3.0.0/tg-v3.0.0-linux-x86_64.tar.gz"
      sha256 "58e37afb32fdade1592f0077707138143341e5ac33eee950be33eb27012ec50b"
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
