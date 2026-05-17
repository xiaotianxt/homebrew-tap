class Cx < Formula
  desc "Fast local Codex launcher, stdin wrapper, and slot manager"
  homepage "https://github.com/xiaotianxt/cx"
  url "https://github.com/xiaotianxt/cx/releases/download/v0.4.20/cx-v0.4.20-darwin-arm64.tar.gz"
  sha256 "f260ca4015df5eaebf06d4ecfd91ab0ed68a8e95a3608789276282a31bc8cfe0"
  license "MIT"
  version "0.4.20"

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
