from patch_sql import patch


def test_charset_removed():
    text = "ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='x';"
    assert "DEFAULT CHARSET" not in patch(text)


def test_collate_removed():
    text = "ENGINE=InnoDB DEFAULT COLLATE latin1_swedish_ci COMMENT='x';"
    assert "DEFAULT COLLATE" not in patch(text)


def test_nwb_file_name_shortened():
    text = " `nwb_file_name` varchar(255) NOT NULL"
    result = patch(text)
    assert "varchar(64)" in result
    assert "`nwb_file_name`" in result


def test_interval_list_name_shortened():
    text = " `interval_list_name` varchar(200) NOT NULL"
    assert "varchar(170)" in patch(text)


def test_artifact_name_shortened():
    text = " `artifact_removed_interval_list_name` varchar(200) NOT NULL"
    assert "varchar(128)" in patch(text)


def test_unlisted_field_unchanged():
    text = " `some_other_field` varchar(255) NOT NULL"
    assert patch(text) == text
