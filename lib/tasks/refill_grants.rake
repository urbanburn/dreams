# to import run bundle exec rake refill_grants

desc "Refill grants to all users"
task :refill_grants => [:environment] do

  User.all.each do |user|
    refill = 0
    if Rails.application.config.grant_refill.to_i > user.grants.to_i
      refill = Rails.application.config.grant_refill.to_i - user.grants.to_i
    end
    counter = 0
    refill.times do

      if (Grant.sum(:amount) + User.sum(:grants))*Rails.application.config.coin_rate < Rails.application.config.max_budget_real.to_f
        ActiveRecord::Base.transaction do
          user.grants += 1
          unless user.save
            flash[:notice] = "#{t:errors_str}: #{user.errors.full_messages.uniq.join(', ')}"
            redirect_to camp_path(@camp) and return
          end
        end
      end
      counter += 1

    end

    puts "Added " + counter.to_s + " grants to " + user.email

  end

end
