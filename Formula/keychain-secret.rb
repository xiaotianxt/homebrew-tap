class KeychainSecret < Formula
  desc "Small stdin-friendly CLI for macOS Keychain secrets"
  homepage "https://github.com/xiaotianxt/keychain-secret"
  url "https://github.com/xiaotianxt/keychain-secret/releases/download/v0.1.0/keychain-secret-v0.1.0-darwin-arm64.tar.gz"
  version "0.1.0"
  sha256 "262ef941f264f184a7381e36866ed53980e26209a7967c4b45cd851dccc9c72b"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "keychain-secret"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keychain-secret --version")
  end
end
