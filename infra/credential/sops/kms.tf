resource "aws_kms_key" "this" {
  description             = "kms key for sops encryption"
  enable_key_rotation     = true # キーローテーションを有効にする
  rotation_period_in_days = 90   # キーのローテーション期間
  deletion_window_in_days = 7    # 削除時の猶予期間
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.project}/${var.env}/sops"
  target_key_id = aws_kms_key.this.key_id
}
