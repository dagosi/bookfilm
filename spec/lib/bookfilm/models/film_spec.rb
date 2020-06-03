require 'spec_helper'

describe Film do
  describe '#plays_on?' do
    context 'when it plays on that date' do
      context 'when there is only one rolling day' do
        subject do
          described_class
            .new(rolling_days: ['monday'])
            .plays_on?('2020-10-05')
        end
        it { is_expected.to be_truthy }
      end

      context 'when there are multiple rolling days' do
        subject do
          described_class
            .new(rolling_days: ['monday', 'saturday', 'sunday'])
            .plays_on?('2020-10-04')
        end
        it { is_expected.to be_truthy }
      end
    end

    context 'when it does not play on that date' do
      subject do
        described_class
          .new(rolling_days: ['monday', 'saturday', 'sunday'])
          .plays_on?('2020-10-07') # Happy humpday!
      end
      it { is_expected.to be_falsey }
    end
  end
end
