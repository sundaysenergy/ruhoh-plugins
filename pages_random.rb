# ./my-blog/plugins/pages_random.rb

module PagesRandom

  # more info here: https://github.com/ruhoh/ruhoh.rb/issues/207#issuecomment-23361123

  # Return n random page objects.
  # Limit can be set in config.yml:
  #   pages:
  #     random_limit: 10
  def random
    limit = config['random_limit'].to_i
    limit = limit > 0 ? limit : 5
    all.sample(limit)
  end

  # Return n random page objects.
  # Limit can be set dynamically by chaining the method call:
  #   {{# pages.random_with_limit.25 }}
  #     <li><a href="{{ url }}">{{ title }}</a></li>
  #   {{/ pages.random_with_limit.25 }}
  def random_with_limit
    @random_with_limit ||= RandomProxy.new(self)
  end

  # Allows arbitrary responses to methods that can be cast to Integers.
  # ex: random_with_limit.5 where "5" can be cast to an Integer
  class RandomProxy < SimpleDelegator
    def method_missing(name, *args, &block)
      __getobj__.all.sample(name.to_s.to_i)
    end

    def respond_to?(method)
      (method.to_s.to_i > 0) ? true : super
    end
  end
end

Ruhoh::Resources::Pages::CollectionView.send(:include, PagesRandom)
