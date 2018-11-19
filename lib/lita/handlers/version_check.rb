# START:route
module Lita
  module Handlers
    class VersionCheck < Handler
      route(/^version check$/i, :check_version, command: true)
      # END:route

      # START:commit_hash
      # Fetch the SHA representing the current git commit in this repository:
      #   e.g. fc648e78f54a74ca92a82d0ff77a9151fcf8e373
      def git_sha
        `git rev-parse HEAD`.strip
      end
      # END:commit_hash

      # START:gemspec_version
      # Asks the bundle command which version of lita-version-check you're
      #   running.
      #
      #   e.g. lita-version-check 0.1.0
      #
      def gemspec_version
        # - list all installed gems in this context and filter for the one named
        #   version check,
        # - strip out all characters other than alphanumerics and . - and space.
        # - trim leading and trailing whitespace
        # - split on whitespace
        # - join the split tokens back together with a uniform single space
        `bundle list | grep lita-version-check`
        .gsub(/[^A-Za-z0-9\.\- ]/i, '') 
        .strip
        .split
        .join(' ')
      end
      # END:gemspec_version

      # START:repo_url
      # Fetch the short-form repository URL of this git repo e.g.
      #   git@github.com:dpritchett/ruby-bookbot.git
      def git_repository_url
        `git config --get remote.origin.url`.strip
      end
      # END:repo_url

      # START:handler
      def check_version(message)
        message.reply [
          "My git revision is [#{git_sha}].",
          "My repository URL is [#{git_repository_url}].",
          '<<<>>>',
          "Brought to you by [#{gemspec_version}]."
        ].join(' ')
      end
      # END:handler

      Lita.register_handler(self)
    end
  end
end