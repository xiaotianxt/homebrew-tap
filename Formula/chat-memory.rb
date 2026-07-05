class ChatMemory < Formula
  desc "Local-first search and capture service for ChatGPT and agent chat history"
  homepage "https://github.com/xiaotianxt/chat-memory"
  url "https://github.com/xiaotianxt/chat-memory/releases/download/v0.1.1/chat-memory-v0.1.1-darwin-arm64.tar.gz"
  sha256 "cd40657a4c38360c9471685f2aad35a154fbfc5bd58c27f1e1cdd8fb9e3755b0"
  license "MIT"
  version "0.1.1"

  depends_on arch: :arm64

  head do
    url "https://github.com/xiaotianxt/chat-memory.git", branch: "main"
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", "--bin", "chat-memory", "--root", prefix, "."
    else
      bin.install "chat-memory"
    end
  end

  def post_install
    (var/"log").mkpath
  end

  service do
    run [
      opt_bin/"chat-memory",
      "chatgpt-serve",
      "--addr", "127.0.0.1:37531",
    ]
    keep_alive true
    log_path var/"log/chat-memory.log"
    error_log_path var/"log/chat-memory.err.log"
  end

  test do
    system "#{bin}/chat-memory", "--help"
  end
end
