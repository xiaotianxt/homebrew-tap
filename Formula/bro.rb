class Bro < Formula
  desc "Rust-native local MCP server for browser automation"
  homepage "https://github.com/xiaotianxt/bro"
  version "1.7.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.7.0/bro-v1.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "a28d55f65be669f1468894f2e4bec131d6ca4d1360304f94da63802c39c32a6c"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.7.0/bro-v1.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "2258e9e0198c4ceca9a768d41b419cb1f4055c727a53b4013c4be5f4c1fa2aff"
    else
      odie "unsupported macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.7.0/bro-v1.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "28017ac03350a91a5a357216868b01e3cdc251f99817088b60eba3218e3fcda9"
    elsif Hardware::CPU.intel?
      url "https://github.com/xiaotianxt/bro/releases/download/v1.7.0/bro-v1.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6850ec47a674e972ac58afd24d85e4a03e7c910c0d270ba103a2cebfdafa00a5"
    else
      odie "unsupported Linux architecture"
    end
  end

  head do
    url "https://github.com/xiaotianxt/bro.git", branch: "main"
    depends_on "rust" => :build
  end

  resource "extension" do
    url "https://github.com/xiaotianxt/bro/releases/download/v1.7.0/bro-extension-v1.7.0.zip"
    sha256 "78c11e5a04edf87aa800577f42c9c94c5d3f06d65ff590689345692fd2739d1e"
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
