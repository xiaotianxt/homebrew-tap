class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.10.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.0/tg-v2.10.0-darwin-arm64.tar.gz"
      sha256 "cb9edc31623b8a49d688e2a4841bf2c2e139481818c5b6cfa90fbb31b561041e"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.0/tg-v2.10.0-linux-arm64.tar.gz"
      sha256 "52772a3921704d0c5ef68809912052543260887a37149f69fb4ccc5a2ae39863"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.10.0/tg-v2.10.0-linux-x86_64.tar.gz"
      sha256 "59a025a3eafe4986b2c7ed08c99c3eb68aae0c43f8004331f772ffab769d9ee8"
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
