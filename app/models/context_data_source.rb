class ContextDataSource < ActiveRecordShared
	belongs_to :context
	belongs_to :data_source
end
