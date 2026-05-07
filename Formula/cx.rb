class Cx < Formula
  desc "Fast local Codex launcher, stdin wrapper, and slot manager"
  homepage "https://github.com/xiaotianxt/cx"
  url "https://github.com/xiaotianxt/cx/releases/download/v0.2.19/cx-v0.2.19-darwin-arm64.tar.gz"
  sha256 "511c4fa15446362edc5103b03515db0c026d9ba46b9d2d691ee4515531cea5ea"
  license "MIT"
  version "0.2.19"

  depends_on arch: :arm64

  head do
    url "https://github.com/xiaotianxt/cx.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", "--bin", "cx", "--root", prefix, "."
    else
      bin.install "cx"
    end
    generate_completions_from_executable(bin/"cx", "completions")
  end

  test do
    system "#{bin}/cx", "--help"
  end
end
