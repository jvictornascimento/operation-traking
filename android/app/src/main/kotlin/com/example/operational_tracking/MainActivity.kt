package com.example.operational_tracking

import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val backupExportChannel = "operational_tracking/backup_export"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, backupExportChannel)
            .setMethodCallHandler { call, result ->
                if (call.method != "shareBackup") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val path = call.argument<String>("path")
                if (path.isNullOrBlank()) {
                    result.error(
                        "INVALID_PATH",
                        "Caminho do arquivo de backup nao informado.",
                        null,
                    )
                    return@setMethodCallHandler
                }

                val file = File(path)
                if (!file.exists()) {
                    result.error(
                        "FILE_NOT_FOUND",
                        "Arquivo de backup nao encontrado no dispositivo.",
                        null,
                    )
                    return@setMethodCallHandler
                }

                val uri = FileProvider.getUriForFile(
                    this,
                    "$packageName.fileprovider",
                    file,
                )
                val sendIntent = Intent(Intent.ACTION_SEND).apply {
                    type = "application/octet-stream"
                    putExtra(Intent.EXTRA_STREAM, uri)
                    putExtra(Intent.EXTRA_SUBJECT, "Backup Operational Tracking")
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }

                startActivity(Intent.createChooser(sendIntent, "Compartilhar backup"))
                result.success(null)
            }
    }
}
