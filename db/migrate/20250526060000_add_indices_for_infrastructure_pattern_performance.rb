class AddIndicesForInfrastructurePatternPerformance < ActiveRecord::Migration[7.0]
  def change
    add_index :wonder_infrastructure_patterns, 
              [:infrastructure_pattern_id, :wonder_id], 
              name: 'idx_wip_on_ip_and_wonder'
              
    add_index :infrastructure_pattern_dependencies,
              [:infrastructure_pattern_id, :dependable_type, :dependable_id],
              name: 'idx_ipd_on_ip_and_dependable'
              
    add_index :infrastructure_patterns, 
              [:position, :visibility],
              name: 'idx_ip_on_position_and_visibility'
  end
end 