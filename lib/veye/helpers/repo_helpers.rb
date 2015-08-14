module RepoHelpers
  def encode_repo_key(repo_key)
    repo_key.to_s.gsub(/\//, ":").gsub(/\./, "~")
  end
end
