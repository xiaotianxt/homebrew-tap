class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.4.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.4/bro-v1.4.4-aarch64-apple-darwin.tar.gz"
      sha256 "2721d080dcf3eb6b28e7ac8c2a46df15dd1af62d1748baec10866ba2970054bc"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.4/bro-v1.4.4-x86_64-apple-darwin.tar.gz"
      sha256 "1f2d88030d915707ac9981c91c0bfa841bae51f206d83f3d1b99fefbf3f3496c"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.4/bro-v1.4.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3ec9e1b34faaa0af6a77f3be3e8e338856d832c8b893e18e38287cf4804da0f4"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.4.4/bro-v1.4.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "44344d150663b4b5d7e893d152132a4b2043f5964dbcf7306d1cd3878ed003eb"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.4.4/bro-extension-v1.4.4.zip"
    sha256 "c177f986f0c4499c179300d85aac537e7de167d99b0207c94bbe934645d332ef"
  end

  def install
    if build.head?
      system "cargo", "install", "--locked", "--bin", "bro", "--root", prefix, "."
    else
      bin.install "bro"
    end

    resource("extension").stage do
      (share/"bro/extension").install Dir["*"]
    end
  end

  service do
    run [opt_bin/"bro", "serve"]
    keep_alive true
    log_path var/"log/bro.log"
    error_log_path var/"log/bro.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bro --version")
    assert_predicate share/"bro/extension/manifest.json", :exist?
  end
end
