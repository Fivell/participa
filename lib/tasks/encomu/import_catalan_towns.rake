namespace :encomu do
  def normalize(code)
    full_width = format("%06d", code)

    "m_#{full_width[0..1]}_#{full_width[2..4]}_#{full_width[5]}"
  end

  desc "[encomu] Imports Catalonia geographical information from a CSV"
  task :import_catalan_towns => :environment do
    CSV.foreach('db/idescat/catalan_town_info.tsv', col_sep: "\t",
                                                    headers: true,
                                                    converters: :all) do |row|
      row["code"] = normalize(row["code"])

      CatalanTown.create!(row.to_hash)
    end
  end
end
