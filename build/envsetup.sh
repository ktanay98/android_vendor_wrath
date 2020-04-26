function __print_wrath_functions_help() {
cat <<EOF
Additional WRATH functions:
- gerrit:          Adds a remote for WrathOS Gerrit
EOF
}

function repopick() {
    T=$(gettop)
    $T/vendor/wrath/build/tools/repopick.py $@
}

function gerrit()
{
    if [ ! -d ".git" ]; then
        echo -e "Please run this inside a git directory";
    else
        if [[ ! -z $(git config --get remote.gerrit.url) ]]; then
            git remote rm gerrit;
        fi
        [[ -z "${GERRIT_USER}" ]] && export GERRIT_USER=$(git config --get gerrit.wrathos.com.username);
        if [[ -z "${GERRIT_USER}" ]]; then
            git remote add gerrit $(git remote -v | grep WrathOS | awk '{print $2}' | uniq | sed -e "s|https://github.com/WrathOS|ssh://gerrit.wrathos.com:29418/WrathOS|");
        else
            git remote add gerrit $(git remote -v | grep WrathOS | awk '{print $2}' | uniq | sed -e "s|https://github.com/WrathOS|ssh://${GERRIT_USER}@gerrit.wrathos.com:29418/WrathOS|");
        fi
    fi
}

function fixup_common_out_dir() {
    common_out_dir=$(get_build_var OUT_DIR)/target/common
    target_device=$(get_build_var TARGET_DEVICE)
    if [ ! -z $AOSP_FIXUP_COMMON_OUT ]; then
        if [ -d ${common_out_dir} ] && [ ! -L ${common_out_dir} ]; then
            mv ${common_out_dir} ${common_out_dir}-${target_device}
            ln -s ${common_out_dir}-${target_device} ${common_out_dir}
        else
            [ -L ${common_out_dir} ] && rm ${common_out_dir}
            mkdir -p ${common_out_dir}-${target_device}
            ln -s ${common_out_dir}-${target_device} ${common_out_dir}
        fi
    else
        [ -L ${common_out_dir} ] && rm ${common_out_dir}
        mkdir -p ${common_out_dir}
    fi
}
