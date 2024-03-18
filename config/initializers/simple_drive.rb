module SimpleDrive
  STORAGE_OPTIONS = {
    local_storage: "local_storage",
    database: "database",
    cloud: "cloud"
  }.freeze

  STORAGE_SERVICE = STORAGE_OPTIONS[:cloud]
  LOCAL_STORAGE_PATH = "/Users/mhnd/Documents"
end