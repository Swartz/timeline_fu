class TimelineEvent < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  def self.fire(instance, event_type, opts={})
    opts[:subject] = :self unless opts.has_key?(:subject)

    create_options = [:actor, :subject, :secondary_subject].inject({}) do |memo, sym|
      case opts[sym]
      when :self
        memo[sym] = instance
      else
        memo[sym] = (opts[sym].kind_of?(Symbol) ? instance.send(opts[sym]) : opts[sym]) if opts[sym]
      end
      memo
    end
    create_options[:event_type] = event_type.to_s

    create!(create_options)
  end
end