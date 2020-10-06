# configura o projeto GCP
provider "google" {
  credentials = "${file("testeengenharia-37bb9c2a2bc9.json")}"
  project = "${var.project_id}"
  region = "${var.regiao}"
  zone   = "${var.zone}"
}

resource "google_pubsub_topic" "quote_price" {
  name = "quote_price"
  }

resource "google_pubsub_topic" "bill_materials" {
  name = "bill_materials"
  }

resource "google_pubsub_topic" "comp_boss" {
  name = "comp_boss"
  }

resource "google_storage_bucket" "bucket" {
  name = "functionrecursos"
  location      = "US"
  force_destroy = true
}

resource "google_storage_bucket_object" "archive" {
  name   = "function.zip"
  bucket = google_storage_bucket.bucket.name
  source = "C:/Users/PC/Desktop/TesteEngenheiroDados/terraform/artefacts/function.zip"
}

resource "google_storage_bucket_object" "content_folder" {
  name          = "temp/"
  content       = "Not really a directory, but it's empty."
  bucket        = "${google_storage_bucket.bucket.name}"
}

resource "google_cloudfunctions_function" "function" {
  project = "${var.project_id}"
  region = "${var.regiao}"
  name        = "ingestionTerraform"
  description = "ingestao de dados atraves de rest"
  runtime     = "python37"
  service_account_email = "function@testeengenharia.iam.gserviceaccount.com"

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "trigger"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_bigquery_dataset" "tubes" {
  dataset_id                  = "tubes"
  friendly_name               = "tubes"
  description                 = "tabela com os dados recebidos dos topicos pub/sub"
  location                    = "US"

}


resource "google_bigquery_table" "tb_quoteprice" {
  dataset_id = google_bigquery_dataset.tubes.dataset_id
  table_id   = "tb_quoteprice"

  schema = <<EOF
[
  {
    "name": "tube_assembly_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "supplier",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quote_date",
    "type": "DATE",
    "mode": "NULLABLE"
  },
  {
    "name": "annual_usage",
    "type": "INT64",
    "mode": "NULLABLE"
  },
  {
    "name": "min_order_quantity",
    "type": "INT64",
    "mode": "NULLABLE"
  },
  {
    "name": "bracket_pricing",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity",
    "type": "INT64",
    "mode": "NULLABLE"
  },
  {
    "name": "cost",
    "type": "FLOAT64",
    "mode": "NULLABLE"
  }
]
EOF

}

resource "google_bigquery_table" "tb_billmaterials" {
  dataset_id = google_bigquery_dataset.tubes.dataset_id
  table_id   = "tb_billmaterials"

  schema = <<EOF
[
  {
    "name": "tube_assembly_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "component_id_1",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_1",
    "type": "INT64",
    "mode": "NULLABLE"
  },
    {
    "name": "component_id_2",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_2",
    "type": "INT64",
    "mode": "NULLABLE"
  },
    {
    "name": "component_id_3",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_3",
    "type": "INT64",
    "mode": "NULLABLE"
  },
    {
    "name": "component_id_4",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_4",
    "type": "INT64",
    "mode": "NULLABLE"
  },
    {
    "name": "component_id_5",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_5",
    "type": "INT64",
    "mode": "NULLABLE"
  },
    {
    "name": "component_id_6",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_6",
    "type": "INT64",
    "mode": "NULLABLE"
  },
    {
    "name": "component_id_7",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_7",
    "type": "INT64",
    "mode": "NULLABLE"
  },
     {
    "name": "component_id_8",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quantity_8",
    "type": "INT64",
    "mode": "NULLABLE"
  } 
]
EOF
}
resource "google_bigquery_table" "tb_compboss" {
  dataset_id = google_bigquery_dataset.tubes.dataset_id
  table_id   = "tb_compboss"

  schema = <<EOF
[
  {
    "name": "component_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "component_type_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
    {
    "name": "connection_type_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "outside_shape",
    "type": "STRING",
    "mode": "NULLABLE"
  },
    {
    "name": "base_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "height_over_tube",
    "type": "FLOAT64",
    "mode": "NULLABLE"
  },
    {
    "name": "bolt_pattern_long",
    "type": "FLOAT64",
    "mode": "NULLABLE"
  },
  {
    "name": "bolt_pattern_wide",
    "type": "FLOAT64",
    "mode": "NULLABLE"
  },
    {
    "name": "groove",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "base_diameter",
    "type": "FLOAT64",
    "mode": "NULLABLE"
  },
    {
    "name": "shoulder_diameter",
    "type": "FLOAT64",
    "mode": "NULLABLE"
  },
  {
    "name": "unique_feature",
    "type": "STRING",
    "mode": "NULLABLE"
  },
    {
    "name": "orientation",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "weight",
    "type": "FLOAT64",
    "mode": "NULLABLE"
}
]
EOF
}


resource "google_bigquery_dataset" "dw" {
  dataset_id                  = "dw_tubes"
  friendly_name               = "dw_tubes"
  description                 = "tabela com os dados tratados"
  location                    = "US"
  
}

resource "google_bigquery_table" "tb_dim_date" {
  dataset_id = google_bigquery_dataset.dw.dataset_id
  table_id   = "tb_dim_date"

  schema = <<EOF
[
  {
    "name": "date",
    "type": "DATE",
    "mode": "NULLABLE"
  },
  {
    "name": "day",
    "type": "string",
    "mode": "NULLABLE"
  }, 
  {
    "name": "dayweek",
    "type": "string",
    "mode": "NULLABLE"
  },
  {
    "name": "month",
    "type": "string",
    "mode": "NULLABLE"
  },
  {
    "name": "quarter",
    "type": "string",
    "mode": "NULLABLE"
  },
  {
    "name": "year",
    "type": "string",
    "mode": "NULLABLE"
  }
  ]
 EOF
 }

resource "google_bigquery_table" "tb_dim_tube_assembly" {
  dataset_id = google_bigquery_dataset.dw.dataset_id
  table_id   = "tb_dim_tube_assembly"

  schema = <<EOF
[
  {
    "name": "tube_assembly_id",
    "type": "string",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "INT64",
    "mode": "NULLABLE"
  }
  ]
 EOF
 }

 resource "google_bigquery_table" "tb_dim_supplier" {
  dataset_id = google_bigquery_dataset.dw.dataset_id
  table_id   = "tb_dim_supplier"

  schema = <<EOF
[
  {
    "name": "supplier",
    "type": "string",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "INT64",
    "mode": "NULLABLE"
  }
  ]
EOF
 }

  resource "google_bigquery_table" "tb_dim_bracket_pricing" {
  dataset_id = google_bigquery_dataset.dw.dataset_id
  table_id   = "tb_dim_bracket_pricing"

  schema = <<EOF
[
  {
    "name": "bracket_pricing",
    "type": "string",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "INT64",
    "mode": "NULLABLE"
  }
  ]
EOF
 }

   resource "google_bigquery_table" "tb_fact_quotePrice" {
  dataset_id = google_bigquery_dataset.dw.dataset_id
  table_id   = "tb_fact_quotePrice"

  schema = <<EOF
[
  {
    "name": "quote_date",
    "type": "date",
    "mode": "NULLABLE"
  },
  {
    "name": "idtubeAssembly",
    "type": "INT64",
    "mode": "NULLABLE"
  },
   {
    "name": "idSupplier",
    "type": "INT64",
    "mode": "NULLABLE"
  },
   {
    "name": "idBracketPrice",
    "type": "INT64",
    "mode": "NULLABLE"
  },
  {
    "name": "AnnualUsage",
    "type": "INT64",
    "mode": "NULLABLE"
  },
  {
    "name": "MinOrderQuantity",
    "type": "INT64",
    "mode": "NULLABLE"
  },
  {
    "name": "Quantity",
    "type": "INT64",
    "mode": "NULLABLE"
  },
  {
    "name": "cost",
    "type": "FLOAT64",
    "mode": "NULLABLE"
  }
  ]
EOF
 }


resource "google_dataflow_job" "ps-to-bq-quote-price" {
  name              = "ps-to-bq-quote-price"
  template_gcs_path = "gs://dataflow-templates/latest/PubSub_to_BigQuery"
  temp_gcs_location = "gs://functionrecursos/temp"
  region = "${var.regiao}"
  parameters = {
    inputTopic = "projects/testeengenharia/topics/quote_price"
    outputTableSpec = "testeengenharia:tubes.tb_quoteprice"
  }
}

resource "google_dataflow_job" "ps-to-bq-bill_materials" {
  name              = "ps-to-bq-bill-materials"
  template_gcs_path = "gs://dataflow-templates/latest/PubSub_to_BigQuery"
  temp_gcs_location = "gs://functionrecursos/temp"
  region = "${var.regiao}"
  parameters = {
    inputTopic = "projects/testeengenharia/topics/bill_materials"
    outputTableSpec = "testeengenharia:tubes.tb_billmaterials"
  }
}

resource "google_dataflow_job" "ps-to-bq-comp_boss" {
  name              = "ps-to-bq-comp-boss"
  template_gcs_path = "gs://dataflow-templates/latest/PubSub_to_BigQuery"
  temp_gcs_location = "gs://functionrecursos/temp"
  region = "${var.regiao}"
  parameters = {
    inputTopic = "projects/testeengenharia/topics/comp_boss"
    outputTableSpec = "testeengenharia:tubes.tb_compboss"
  }
}


resource "google_bigquery_job" "job1" {
  job_id     = "job_dim_date"

  query {
    query = "SELECT a.quote_date as date, EXTRACT(DAY FROM a.quote_date) as day, EXTRACT(DAYOFWEEK from a.quote_date) as dayWeek, EXTRACT(MONTH FROM a.quote_date) as month, EXTRACT(quarter FROM a.quote_date) as quarter,EXTRACT(year FROM a.quote_date) as year  FROM `testeengenharia.tubes.tb_quoteprice` as a"

    destination_table {
      project_id = "${var.project_id}"
      dataset_id = google_bigquery_dataset.dw.dataset_id
      table_id   = google_bigquery_table.tb_dim_date.table_id
    }

    allow_large_results = true
    flatten_results = true

    script_options {
      key_result_statement = "LAST"
    }
  }
}