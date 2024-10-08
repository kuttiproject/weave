package main

import (
	"os"

	cni "github.com/containernetworking/cni/pkg/skel"
	"github.com/containernetworking/cni/pkg/version"

	bv "github.com/containernetworking/plugins/pkg/utils/buildversion"
	weaveapi "github.com/kuttiproject/weave/internal/api"
	"github.com/kuttiproject/weave/internal/common"
	ipamplugin "github.com/kuttiproject/weave/internal/plugin/ipam"
	netplugin "github.com/kuttiproject/weave/internal/plugin/net"
)

func cniNet(args []string) error {
	weave := weaveapi.NewClient(os.Getenv("WEAVE_HTTP_ADDR"), common.Log)
	n := netplugin.NewCNIPlugin(weave)
	cni.PluginMain(n.CmdAdd, n.CmdCheck, n.CmdDel, version.All, bv.BuildString("weave net"))
	return nil
}

func cniIPAM(args []string) error {
	weave := weaveapi.NewClient(os.Getenv("WEAVE_HTTP_ADDR"), common.Log)
	i := ipamplugin.NewIpam(weave)
	cni.PluginMain(i.CmdAdd, i.CmdCheck, i.CmdDel, version.All, bv.BuildString("weave net"))
	return nil
}
