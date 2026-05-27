from patch_env import patch

DEV = "  - spyglass-neuro==0.5.4a2.dev23+g89e3be86.d20250424\n"
STABLE = "  - spyglass-neuro==0.5.5\n"
ALPHA = "  - spyglass-neuro==0.5.4a1\n"
PREFIX = "prefix: /home/user/anaconda3/envs/spyglass\n"
SHA = "89e3be86"


def test_dev_version_points_to_commit():
    result = patch(DEV)
    assert (
        f"spyglass-neuro @ git+https://github.com/LorenFrankLab/spyglass@{SHA}"
        in result
    )


def test_dev_version_removes_pin():
    assert "==" not in patch(DEV)


def test_stable_version_unchanged():
    assert patch(STABLE) == STABLE


def test_alpha_version_unchanged():
    assert patch(ALPHA) == ALPHA


def test_prefix_stripped():
    text = "name: spyglass\n" + PREFIX
    result = patch(text)
    assert "prefix:" not in result
    assert "name: spyglass\n" in result


def test_no_prefix_unchanged():
    text = "name: spyglass\ndependencies:\n  - numpy\n"
    assert patch(text) == text
