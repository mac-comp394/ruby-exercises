require "aasm"

class Door
  include AASM

  aasm do
    state :closed, initial: true
    state :open

    event :open do
      transitions to: :open, if: [:deadbolt_unlocked?, :knob_unlocked?]
    end

    event :close do
      transitions to: :closed, if: :deadbolt_unlocked?
    end
  end

  def self.generate_lock(lock_type)
    aasm (lock_type + "_lock").to_sym, namespace: lock_type.to_sym do
      state :unlocked, initial: true
      state :locked

      event ("lock_" + lock_type).to_sym do
        transitions to: :locked
      end

      event ("unlock_" + lock_type).to_sym do
        transitions to: :unlocked
      end
    end
  end

["deadbolt", "knob"].each { |lock_type| generate_lock lock_type }

end
