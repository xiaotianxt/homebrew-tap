class ChatMemory < Formula
  desc "Local-first search and capture service for ChatGPT and agent chat history"
  homepage "https://github.com/xiaotianxt/chat-memory"
  url "https://github.com/xiaotianxt/chat-memory/releases/download/v0.1.0/chat-memory-v0.1.0-darwin-arm64.tar.gz"
  sha256 "31d1b87494024a9309d5fbfc1cde713d45c2cbdaf3e5820e44ea6e351eedb8c0"
  license "MIT"
  version "0.1.0"

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
    (var/"chat-memory").mkpath
    (var/"log").mkpath
  end

  service do
    run [
      opt_bin/"chat-memory",
      "--cache", var/"chat-memory/index.sqlite3",
      "chatgpt-serve",
      "--addr", "127.0.0.1:37531",
      "--token-file", var/"chat-memory/chatgpt-ingest-token"
    ]
    keep_alive true
    log_path var/"log/chat-memory.log"
    error_log_path var/"log/chat-memory.err.log"
  end

  test do
    system "#{bin}/chat-memory", "--help"
  end
end
