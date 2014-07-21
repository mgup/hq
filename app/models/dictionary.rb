class Dictionary < ActiveRecord::Base
  self.table_name = 'dictionary'

  alias_attribute :id, :dictionary_id

  alias_attribute :ip, :dictionary_ip
  alias_attribute :rp, :dictionary_rp
  alias_attribute :dp, :dictionary_dp
  alias_attribute :vp, :dictionary_vp
  alias_attribute :tp, :dictionary_tp
  alias_attribute :pp, :dictionary_pp

  # validates :ip, presence: true
  # validates :rp, presence: true
  # validates :dp, presence: true
  # validates :vp, presence: true
  # validates :tp, presence: true
  # validates :pp, presence: true
end