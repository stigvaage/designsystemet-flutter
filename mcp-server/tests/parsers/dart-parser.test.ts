import { describe, it, expect } from "vitest";
import path from "node:path";
import { parseComponent } from "../../src/parsers/dart-parser.js";

const repoRoot = "/Users/shv/git/repos/komponentbibliotek.flutter";

describe("parseComponent", () => {
  describe("DsButton", () => {
    const buttonPath = path.join(
      repoRoot,
      "lib/src/components/button/ds_button.dart"
    );
    const component = parseComponent(buttonPath, repoRoot);

    it("should parse the class name as DsButton", () => {
      expect(component.name).toBe("DsButton");
    });

    it("should find variant property with type DsButtonVariant and default DsButtonVariant.primary", () => {
      const variant = component.properties.find((p) => p.name === "variant");
      expect(variant).toBeDefined();
      expect(variant!.type).toBe("DsButtonVariant");
      expect(variant!.defaultValue).toBe("DsButtonVariant.primary");
    });

    it("should find onPressed as a required property with type VoidCallback?", () => {
      const onPressed = component.properties.find(
        (p) => p.name === "onPressed"
      );
      expect(onPressed).toBeDefined();
      expect(onPressed!.type).toBe("VoidCallback?");
      expect(onPressed!.required).toBe(false);
    });

    it("should find child as a required property with type Widget", () => {
      const child = component.properties.find((p) => p.name === "child");
      expect(child).toBeDefined();
      expect(child!.type).toBe("Widget");
      expect(child!.required).toBe(true);
    });

    it("should find disabled with default value false", () => {
      const disabled = component.properties.find((p) => p.name === "disabled");
      expect(disabled).toBeDefined();
      expect(disabled!.defaultValue).toBe("false");
    });

    it("should find loading with default value false", () => {
      const loading = component.properties.find((p) => p.name === "loading");
      expect(loading).toBeDefined();
      expect(loading!.defaultValue).toBe("false");
    });
  });

  describe("DsAlert", () => {
    const alertPath = path.join(
      repoRoot,
      "lib/src/components/alert/ds_alert.dart"
    );
    const component = parseComponent(alertPath, repoRoot);

    it("should parse the class name as DsAlert", () => {
      expect(component.name).toBe("DsAlert");
    });

    it("should find severity property with default DsSeverity.info", () => {
      const severity = component.properties.find(
        (p) => p.name === "severity"
      );
      expect(severity).toBeDefined();
      expect(severity!.defaultValue).toBe("DsSeverity.info");
    });

    it("should find child as a required property", () => {
      const child = component.properties.find((p) => p.name === "child");
      expect(child).toBeDefined();
      expect(child!.required).toBe(true);
    });

    it("should find closable with default value false", () => {
      const closable = component.properties.find(
        (p) => p.name === "closable"
      );
      expect(closable).toBeDefined();
      expect(closable!.defaultValue).toBe("false");
    });
  });
});
