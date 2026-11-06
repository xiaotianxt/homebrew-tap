class Tg < Formula
  desc "本地 Telegram 桌面聊天记录读取 CLI 工具"
  homepage "https://github.com/xiaotianxt/tg"
  version "2.4.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.4/tg-v2.4.4-darwin-arm64.tar.gz"
      sha256 "6c5ef47d74c4364def33a7af49df77b2888ccb00cc2080ce80d05358b4e42387"
    else
      odie "tg provides prebuilt macOS releases for Apple Silicon only"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.4/tg-v2.4.4-linux-arm64.tar.gz"
      sha256 "5e0bd372a5f120f04287b5cfb57c747aab9aeabd97ef40b9f882c760a630a1ea"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/tg/releases/download/v2.4.4/tg-v2.4.4-linux-x86_64.tar.gz"
      sha256 "318e3ff2644395b1a785561ae0b79051aff5295284f49ebf6665e809556f659f"
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
